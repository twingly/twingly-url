# Twingly::URL

[![Build Status](https://travis-ci.org/twingly/twingly-url.svg?branch=master)](https://travis-ci.org/twingly/twingly-url)

Twingly URL tools.

* `twingly/url` - Parse and validate URLs
    * `Twingly::URL.parse` - Returns one or more `Twingly::URL` instance
* `twingly/url/hasher` - Generate URL hashes suitable for primary keys
    * `Twingly::URL::Hasher.taskdb_hash(url)` - MD5 hexdigest
    * `Twingly::URL::Hasher.blogstream_hash(url)` - MD5 hexdigest
    * `Twingly::URL::Hasher.documentdb_hash(url)` - SHA256 unsigned long, native endian digest
    * `Twingly::URL::Hasher.autopingdb_hash(url)` - SHA256 64-bit signed, native endian digest
    * `Twingly::URL::Hasher.pingloggerdb_hash(url)` - SHA256 64-bit unsigned, native endian digest
* `twingly/url/utilities` - Utilities to work with URLs
    * `Twingly::URL::Utilities.extract_valid_urls` - Returns Array of valid `Twingly::URL`

## Getting Started

Install the gem:

    gem install twingly-url

Usage (this output was created with [`examples/url.rb`][examples]):

```ruby
require "twingly/url"

url = Twingly::URL.parse("http://www.twingly.co.uk/search")
url.scheme              # => "http"
url.trd                 # => "www"
url.sld                 # => "twingly"
url.tld                 # => "co.uk"
url.domain              # => "twingly.co.uk"
url.host                # => "www.twingly.co.uk"
url.origin              # => "http://www.twingly.co.uk"
url.path                # => "/search"
url.without_scheme      # => "//www.twingly.co.uk/search"
url.valid?              # => "true"

url = Twingly::URL.parse("https://admin:correcthorsebatterystaple@example.com/")
url.scheme              # => "https"
url.trd                 # => ""
url.sld                 # => "example"
url.tld                 # => "com"
url.domain              # => "example.com"
url.host                # => "example.com"
url.origin              # => "https://example.com"
url.path                # => "/"
url.without_scheme      # => "//admin:correcthorsebatterystaple@example.com/"
url.userinfo            # => "admin:correcthorsebatterystaple"
url.user                # => "admin"
url.password            # => "correcthorsebatterystaple"
url.valid?              # => "true"
```

### Dependencies

The gem requires libidn.

    sudo apt-get install libidn11 # Ubuntu
    brew install libidn # OS X

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake profile:normalize

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

### Code coverage

[SimpleCov](https://github.com/colszowka/simplecov) is used to generate a code coverage report on every test run. Open it in your browser with:

    open tmp/coverage/index.html

When the tests run on Travis CI, the coverage report is sent to [Coveralls](https://coveralls.io/).

## Release workflow

* Update the [examples] in this README if needed.

* Bump the version in `lib/twingly/version.rb` in a commit, no need to push (the release task does that).

* Make sure you are logged in as [twingly][twingly-rubygems] at RubyGems.org.

* Build and [publish](http://guides.rubygems.org/publishing/) the gem. This will create the proper tag in git, push the commit and tag and upload to RubyGems.

        bundle exec rake release

[twingly-rubygems]: https://rubygems.org/profiles/twingly
[ruby-prof]: http://ruby-prof.rubyforge.org/
[examples]: examples/url.rb
