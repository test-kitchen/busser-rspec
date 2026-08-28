require_relative "../../spec_helper"

require "shellwords"
require "busser/runner_plugin/rspec"

describe Busser::RunnerPlugin::Rspec do
  describe ".runner_command" do
    let(:cmd) do
      Busser::RunnerPlugin::Rspec.runner_command("/gems/busser-rspec/lib/busser/rspec/runner.rb",
        "/opt/busser/suites/rspec")
    end

    it "runs the runner script against the suite" do
      _(Shellwords.split(cmd)).must_equal [
        "/gems/busser-rspec/lib/busser/rspec/runner.rb",
        "-I", "/opt/busser/suites/rspec",
        "-I", "/opt/busser/suites/rspec/lib",
        "/opt/busser/suites/rspec",
      ]
    end

    # Documented behaviour: spec_helper.rb is required without a relative path,
    # which only works while the suite is on the load path.
    it "puts the suite and its lib directory on the load path" do
      _(Shellwords.split(cmd).each_cons(2).select { |flag, _| flag == "-I" }.map(&:last))
        .must_equal ["/opt/busser/suites/rspec", "/opt/busser/suites/rspec/lib"]
    end

    it "quotes a suite path containing spaces" do
      cmd = Busser::RunnerPlugin::Rspec.runner_command("/a/runner.rb", "/tmp/my tests/rspec")

      _(Shellwords.split(cmd)).must_equal [
        "/a/runner.rb",
        "-I", "/tmp/my tests/rspec",
        "-I", "/tmp/my tests/rspec/lib",
        "/tmp/my tests/rspec",
      ]
    end

    it "accepts a Pathname suite" do
      cmd = Busser::RunnerPlugin::Rspec.runner_command("/a/runner.rb", Pathname.new("/b/rspec"))
      _(Shellwords.split(cmd).last).must_equal "/b/rspec"
    end
  end
end
