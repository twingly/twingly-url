# twingly-url-normalizer

[![Build Status](https://magnum.travis-ci.com/twingly/twingly-url-normalizer.png?token=ADz8fWxRD3uP4KZPPZQS&branch=master)](https://magnum.travis-ci.com/twingly/twingly-url-normalizer)

Ruby gem for URL normalization

## Example

```
irb(main):001:0> Twingly::URL::Normalizer.normalize('http://duh.se')
=> ["http://www.duh.se"]
irb(main):002:0> Twingly::URL::Normalizer.normalize('http://duh.se http://blog.twingly.com/')
=> ["http://www.duh.se", "http://blog.twingly.com/"]
irb(main):003:0>
```

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake test:profile

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

[ruby-prof]: http://ruby-prof.rubyforge.org/
