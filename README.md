# Twingly::URL

[![Build Status](https://magnum.travis-ci.com/twingly/twingly-url-normalizer.png?token=ADz8fWxRD3uP4KZPPZQS&branch=master)](https://magnum.travis-ci.com/twingly/twingly-url-normalizer)

Twingly URL tools.

* `twingly/url` - Parse and validate URLs
    * `Twingly::URL.parse` - Returns a Struct with `#url` and `#domain` accessors
    * `Twingly::URL.validate` - Validates a URL
* `twingly/url/normalizer` - Normalize URLs
    * `Twingly::URL::Normalizer.normalize(string)` - Extracts URLs from string (Array)
* `twingly/url/hasher` - Generate URL hashes suitable for primary keys
    * `Twingly::URL::Hasher.documentdb_hash(url)` - MD5 hexdigest
    * `Twingly::URL::Hasher.blogstream_hash(url)` - SHA256 unsigned long, native endian digest
    * `Twingly::URL::Hasher.autopingdb_hash(url)` - SHA256 64-bit signed, native endian digest

## Normalization example

```
[1] pry(main)> require 'twingly/url/normalizer'
=> true
[2] pry(main)> Twingly::URL::Normalizer.normalize('http://duh.se')
=> ["http://www.duh.se/"]
[3] pry(main)> Twingly::URL::Normalizer.normalize('http://duh.se http://blog.twingly.com/')
=> ["http://www.duh.se/", "http://blog.twingly.com/"]
[4] pry(main)> Twingly::URL::Normalizer.normalize('no URL')
=> []
```

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake test:profile

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

[ruby-prof]: http://ruby-prof.rubyforge.org/
