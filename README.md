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

## Installation

    gem install twingly-url

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake test:profile

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

## Release workflow

* Bump the version in `lib/twingly/version.rb`.

* Make sure you are logged in as [twingly][twingly-rubygems] at RubyGems.org.

* Build and [publish](http://guides.rubygems.org/publishing/) the gem.

        bundle exec rake release

[twingly-rubygems]: https://rubygems.org/profiles/twingly
[ruby-prof]: http://ruby-prof.rubyforge.org/
