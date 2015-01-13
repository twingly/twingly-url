# Twingly::URL

[![Build Status](https://travis-ci.org/twingly/twingly-url.svg?branch=master)](https://travis-ci.org/twingly/twingly-url)

Twingly URL tools.

* `twingly/url` - Parse and validate URLs
    * `Twingly::URL.parse` - Returns a Struct with `#url` and `#domain` accessors
    * `Twingly::URL.validate` - Validates a URL
* `twingly/url/normalizer` - Normalize URLs
    * `Twingly::URL::Normalizer.normalize(string)` - Extracts URLs from string (Array)
* `twingly/url/hasher` - Generate URL hashes suitable for primary keys
    * `Twingly::URL::Hasher.taskdb_hash(url)` - MD5 hexdigest
    * `Twingly::URL::Hasher.blogstream_hash(url)` - MD5 hexdigest
    * `Twingly::URL::Hasher.documentdb_hash(url)` - SHA256 unsigned long, native endian digest
    * `Twingly::URL::Hasher.autopingdb_hash(url)` - SHA256 64-bit signed, native endian digest
    * `Twingly::URL::Hasher.pingloggerdb_hash(url)` - SHA256 64-bit unsigned, native endian digest
* `twingly/url/utilities` - Utilities to work with URLs
    * `Twingly::URL::Utilities.remove_scheme(url)` - Removes scheme from HTTP/HTTPS URLs (`http://twingly.com` -> `//twingly.com`)

## Installation

    gem install twingly-url

## Normalization example

```ruby
require 'twingly/url/normalizer'

Twingly::URL::Normalizer.normalize('http://duh.se')
# => ["http://www.duh.se/"]

Twingly::URL::Normalizer.normalize('http://duh.se http://blog.twingly.com/')
# => ["http://www.duh.se/", "http://blog.twingly.com/"]

Twingly::URL::Normalizer.normalize('no URL')
# => []
```

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake test:profile

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

## Release workflow

Build the gem.

    gem build twingly-url.gemspec

[Publish](http://guides.rubygems.org/publishing/) the gem.

    gem push twingly-url-x.y.z.gem

[ruby-prof]: http://ruby-prof.rubyforge.org/
