# Busser::RunnerPlugin::Rspec

A Busser runner plugin for Rspec

## Status

This software project is no longer under active development as it has no active maintainers. The software may continue to work for some or all use cases, but issues filed in GitHub will most likely not be triaged. If a new maintainer is interested in working on this project please come chat with us in #test-kitchen on Chef Community Slack.

## Installation and Setup

Please read the Busser [plugin usage](plugin_usage) page for more details.

## Usage

Please put test files into [COOKBOOK]/test/integration/[SUITES]/rspec/

```
-- [COOKBOOK]
  `-- test
     `-- integration
        `-- default
           `-- rspec
              `-- spec_helper.rb
              `-- Gemfile
```

You can specify your own test gem dependencies with a `Gemfile` under the `rspec` path, like this: `test/integration/<suite>/rspec/Gemfile`. Don't forget to put `gem "rspec"` there!

## How do I ... ?

### Change the rspec formatter?

You may be familar with using the `rspec -f` flag to change the rspec formatter. RSpec also offers a way to set the formatter from your specs:

```ruby
RSpec.configure do |config|
  # The same as `rspec -f documentation`
  config.add_formatter "documentation"
```

## Development

* Source hosted at [GitHub](https://github.com/opscode/busser-rspec)
* Report issues/questions/feature requests on [GitHub Issues](issues)

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Created and maintained by Adam Jacob (adam@opscode.com)

Based on [busser-serverspec](https://github.com/cl-lab-k/busser-serverspec), created and maintained by HIGUCHI Daisuke (d-higuchi@creationline.com)

## License

Apache 2.0 (see [LICENSE](license))

