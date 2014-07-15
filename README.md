# Twingly::URL

[![Build Status](https://magnum.travis-ci.com/twingly/twingly-url-normalizer.png?token=ADz8fWxRD3uP4KZPPZQS&branch=master)](https://magnum.travis-ci.com/twingly/twingly-url-normalizer)

Twingly URL tools.

* `twingly/url/normalizer` - Normalize URLs

TODO:

* `twingly/url` - Parse and validate URLs
* `twingly/url/hasher` - Generate URL hashes suitable for primary keys

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
