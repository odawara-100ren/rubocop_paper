# RubocopPaper

Converts json-formatted output of rubocop to a CSV format file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop_paper', github: "odawara-100ren/rubocop_paper"
```

And then execute:

```
$ bundle
```

Or you can install it by yourself.
[`specific_install`](https://github.com/rdp/specific_install) gem is needed for gem install.

```
$ gem install specific_install
$ gem specific_install -l "https://github.com/odawara-100ren/rubocop_paper"
```

## Usage

```
$ rubocop_paper --file out.json
```

`-f` is aliase for `--file`.

### Example

```
$ rubocop_paper --file out.json
"./rubocop_file_stat.csv" is successfully created!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubocop_paper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubocopPaper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubocop_paper/blob/master/CODE_OF_CONDUCT.md).
