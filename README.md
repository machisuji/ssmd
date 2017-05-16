# SSMD

[![Build Status](https://travis-ci.org/machisuji/ssmd.svg?branch=master)](https://travis-ci.org/machisuji/ssmd)

Speech Synthesis Markdown (SSMD) is an lightweight alternative syntax for [SSML](https://www.w3.org/TR/speech-synthesis/).
This repository contains both the reference implementation of the SSMD-to-SSML conversion tool (`ssmd`) as well
as the [specification](SPECIFICATION.md) of the language.

## Requirements

The tools and executable specification provided in this repository require **Ruby 2.3.4** or better.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ssmd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ssmd

## Usage

```ruby
require 'ssmd'

ssmd = "hello *SSMD*!"
ssml = SSMD.to_ssml ssmd

puts ssml
# Output: <speak>hello <emphasis>SSMD</emphasis>!</speak>
```

**Note:**

This version is still under development. So far only the following conversions
described in the specification are implemented:

* Text
* Emphasis
* Mark
* Language
* Phoneme
* Prosody

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Tests

Run `rake spec` to run the tests against a given executable.

This implementation and any other can be tested against the SSMD specification.
Said specification is extracted from `SPECIFICATION.md`.
It runs each SSMD snippet through the tested tool and compares it to the output of
the following SSML snippet. If they match the test passes.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/machisuji/ssmd. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
