# busser-rspec

[![Gem Version](https://badge.fury.io/rb/busser-rspec.svg)](https://badge.fury.io/rb/busser-rspec)

A [Busser](https://github.com/test-kitchen/busser) runner plugin that runs
[RSpec](https://rspec.info) examples as integration tests.

Busser installs RSpec on the machine under test during postinstall, then runs
the suite's `rspec` directory against it. Because the examples run on the
machine itself rather than over SSH, they can assert on local files, services
and commands directly.

## Status

This software project is no longer under active development as it has no active
maintainers. The software may continue to work for some or all use cases, but
issues filed in GitHub will most likely not be triaged. If a new maintainer is
interested in working on this project please come chat with us in #test-kitchen
on Chef Community Slack.

## Requirements

Ruby 3.2 or newer, and busser 0.9.0 or newer. The plugin installs RSpec 3.13 or
newer on the machine under test.

## Installation

Busser installs the plugin for you when Test Kitchen runs the suite, so there is
usually nothing to do. To install it by hand:

```bash
busser plugin install busser-rspec
```

## Usage

Put your specs in the `rspec` directory of a suite:

```text
test
`-- integration
    `-- default              # suite name
        `-- rspec
            |-- Gemfile              # optional
            |-- setup-recipe.rb      # optional
            |-- spec_helper.rb
            `-- default_spec.rb
```

The suite directory is passed to RSpec as the spec path, and both it and its
`lib` subdirectory are added to the load path — so `require "spec_helper"` works
from any spec without a relative path.

```ruby
describe "foobar::default" do
  it "creates foobar.txt" do
    expect(File).to exist("/usr/local/foobar.txt")
  end
end
```

### Extra gems

If a `Gemfile` is present in the suite directory, it is `bundle install`ed
before the run. Remember to include RSpec itself:

```ruby
source "https://rubygems.org"

gem "rspec"
```

The install is attempted with `--local` first and falls back to the network, so
gems already present on the machine do not cost a download.

### Chef setup

If a `setup-recipe.rb` is present in the suite directory, it is applied with
`chef-apply` before the specs run. This requires `/opt/chef/bin/chef-apply` on
the machine; the run fails with a clear error if the file is there and Chef is
not.

### Changing the formatter

`rspec -f` is not available here, since Busser invokes the runner itself. Set
the formatter from your specs instead:

```ruby
RSpec.configure do |config|
  # the same as `rspec -f documentation`
  config.add_formatter "documentation"
end
```

## Contributing

Bug reports and pull requests are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md) for how to set up the project, run the test
suite, and format your commits.

## License

Apache License 2.0. See [LICENSE](LICENSE).

Originally created by [Adam Jacob](https://github.com/adamhjk), based on
[Daisuke Higuchi](https://github.com/cl-lab-k)'s
[busser-serverspec](https://github.com/test-kitchen/busser-serverspec).
