#
# Author:: HIGUCHI Daisuke (<d-higuchi@creationline.com>)
#
# Copyright (C) 2013, HIGUCHI Daisuke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "busser/runner_plugin"
require "rubygems" unless defined?(Gem)
require "rbconfig" unless defined?(RbConfig)
require "shellwords" unless defined?(Shellwords)

# A Busser runner plugin for Rspec.
#
# @author Adam Jacob <adam@opscode.com>
#
class Busser::RunnerPlugin::Rspec < Busser::RunnerPlugin::Base

  # Builds the command that runs the suite.
  #
  # The suite directory goes on the load path twice -- itself and its lib
  # subdirectory -- so `require "spec_helper"` works from any spec without a
  # relative path.
  #
  # Every path is quoted. BUSSER_ROOT is user supplied, and an unquoted path
  # containing a space would be split by the shell into arguments RSpec would
  # then treat as extra spec paths.
  #
  # @param runner [String] path to the runner script
  # @param suite [String, Pathname] the suite directory holding the specs
  # @return [String] the command to run
  def self.runner_command(runner, suite)
    suite = suite.to_s
    [
      Shellwords.escape(runner),
      "-I", Shellwords.escape(suite),
      "-I", Shellwords.escape(File.join(suite, "lib")),
      Shellwords.escape(suite)
    ].join(" ")
  end

  # Installs RSpec and bundler onto the machine under test. Runs once, when
  # Busser installs this plugin.
  # Builds the chef-apply command for a suite's setup recipe.
  #
  # @param setup_file [String, Pathname] path to the setup recipe
  # @return [String] the command to run
  def self.chef_apply_command(setup_file)
    "/opt/chef/bin/chef-apply #{Shellwords.escape(setup_file.to_s)}"
  end

  # Builds the bundle install command for a suite's own Gemfile.
  #
  # bundler is invoked through the Ruby running Busser rather than whatever
  # `bundle` is on PATH, since on a machine with several Rubies those differ and
  # the suite's gems would land where the runner cannot see them.
  #
  # The --local attempt is a speed optimisation: it finishes immediately when
  # the gems are already present and fails when it would need the network, so
  # the second attempt is the fallback.
  #
  # @param gemfile [String, Pathname] path to the suite's Gemfile
  # @return [String] the command to run
  def self.bundle_install_command(gemfile)
    bundle = [
      Shellwords.escape(File.join(RbConfig::CONFIG["bindir"], "ruby")),
      Shellwords.escape(File.join(Gem.bindir, "bundle")),
      "install", "--gemfile", Shellwords.escape(gemfile.to_s)
    ].join(" ")

    "#{bundle} --local || #{bundle}"
  end

  postinstall do
    install_gem("rspec", ">= 3.13")
    install_gem("bundler")
  end

  # Runs the suite's specs.
  #
  # If the suite ships a Gemfile its gems are installed first, and if it ships a
  # setup-recipe.rb that recipe is applied with chef-apply to put the machine
  # into a known state.
  #
  # @raise [RuntimeError] if a setup recipe is present but chef-apply is not
  #   installed, since running the specs against an unprepared machine would
  #   produce misleading failures
  # @return [void]
  def test
    rspec_path = suite_path("rspec").to_s

    setup_file = File.join(rspec_path, "setup-recipe.rb")

    Dir.chdir(rspec_path) do

      # Referred from busser-serverspec
      gemfile_path = File.join(rspec_path, "Gemfile")
      if File.exist?(gemfile_path)
        # Bundle install local completes quickly if the gems are already found locally
        # it fails if it needs to talk to the internet. The || below is the fallback
        # to the internet-enabled version. It's a speed optimization.
        banner("Bundle Installing..")
        ENV["PATH"] = [ENV["PATH"], Gem.bindir, RbConfig::CONFIG["bindir"]].join(File::PATH_SEPARATOR)
        run(self.class.bundle_install_command(gemfile_path))
      end

      if File.exist?(setup_file)
        unless File.exist?("/opt/chef/bin/chef-apply")
          raise "You have a chef setup file at #{setup_file}, but /opt/chef/bin/chef-apply does not exist"
        end

        run(self.class.chef_apply_command(setup_file))
      end

      runner = File.expand_path(File.join(File.dirname(__FILE__), "..", "rspec", "runner.rb"))
      run_ruby_script!(self.class.runner_command(runner, rspec_path))
    end
  end
end
