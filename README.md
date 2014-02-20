# twingly-url-normalizer

[![Build Status](https://magnum.travis-ci.com/twingly/twingly-url-normalizer.png?token=ADz8fWxRD3uP4KZPPZQS&branch=master)](https://magnum.travis-ci.com/twingly/twingly-url-normalizer)

Ruby gem for URL normalization

## Example

```
[5] pry(main)> Twingly::URL::Normalizer.normalize('aoeu')
=> []
[6] pry(main)> Twingly::URL::Normalizer.normalize('duh.se')
=> ["http://www.duh.se/"]
```

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    bundle exec rake test:profile

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

[ruby-prof]: http://ruby-prof.rubyforge.org/
