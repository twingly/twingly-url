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
* `twingly/url/utilities` - Utilities to work with URLs
    * `Twingly::URL::Utilities.extract_valid_urls` - Returns Array of valid `Twingly::URL`

## Getting Started

Install the gem:

    gem install twingly-url

Usage (this output was created with [`examples/url.rb`][examples]):

```ruby
require "twingly/url"

url = Twingly::URL.parse("http://www.twingly.co.uk/search")
url.scheme                    # => "http"
url.normalized.scheme         # => "http"
url.trd                       # => "www"
url.normalized.trd            # => "www"
url.sld                       # => "twingly"
url.normalized.sld            # => "twingly"
url.tld                       # => "co.uk"
url.normalized.tld            # => "co.uk"
url.ttld                      # => "uk"
url.normalized.ttld           # => "uk"
url.domain                    # => "twingly.co.uk"
url.normalized.domain         # => "twingly.co.uk"
url.host                      # => "www.twingly.co.uk"
url.normalized.host           # => "www.twingly.co.uk"
url.origin                    # => "http://www.twingly.co.uk"
url.normalized.origin         # => "http://www.twingly.co.uk"
url.path                      # => "/search"
url.normalized.path           # => "/search"
url.without_scheme            # => "//www.twingly.co.uk/search"
url.normalized.without_scheme # => "//www.twingly.co.uk/search"
url.userinfo                  # => ""
url.normalized.userinfo       # => ""
url.user                      # => ""
url.normalized.user           # => ""
url.password                  # => ""
url.normalized.password       # => ""
url.valid?                    # => "true"
url.normalized.valid?         # => "true"
url.to_s                      # => "http://www.twingly.co.uk/search"
url.normalized.to_s           # => "http://www.twingly.co.uk/search"

url = Twingly::URL.parse("http://räksmörgås.макдональдс.рф/foo")
url.scheme                    # => "http"
url.normalized.scheme         # => "http"
url.trd                       # => "räksmörgås"
url.normalized.trd            # => "xn--rksmrgs-5wao1o"
url.sld                       # => "макдональдс"
url.normalized.sld            # => "xn--80aalb1aicli8a5i"
url.tld                       # => "рф"
url.normalized.tld            # => "xn--p1ai"
url.ttld                      # => "рф"
url.normalized.ttld           # => "xn--p1ai"
url.domain                    # => "макдональдс.рф"
url.normalized.domain         # => "xn--80aalb1aicli8a5i.xn--p1ai"
url.host                      # => "räksmörgås.макдональдс.рф"
url.normalized.host           # => "xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.origin                    # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.normalized.origin         # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.path                      # => "/foo"
url.normalized.path           # => "/foo"
url.without_scheme            # => "//räksmörgås.макдональдс.рф/foo"
url.normalized.without_scheme # => "//xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"
url.userinfo                  # => ""
url.normalized.userinfo       # => ""
url.user                      # => ""
url.normalized.user           # => ""
url.password                  # => ""
url.normalized.password       # => ""
url.valid?                    # => "true"
url.normalized.valid?         # => "true"
url.to_s                      # => "http://räksmörgås.макдональдс.рф/foo"
url.normalized.to_s           # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"

url = Twingly::URL.parse("http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo")
url.scheme                    # => "http"
url.normalized.scheme         # => "http"
url.trd                       # => "xn--rksmrgs-5wao1o"
url.normalized.trd            # => "xn--rksmrgs-5wao1o"
url.sld                       # => "xn--80aalb1aicli8a5i"
url.normalized.sld            # => "xn--80aalb1aicli8a5i"
url.tld                       # => "xn--p1ai"
url.normalized.tld            # => "xn--p1ai"
url.ttld                      # => "xn--p1ai"
url.normalized.ttld           # => "xn--p1ai"
url.domain                    # => "xn--80aalb1aicli8a5i.xn--p1ai"
url.normalized.domain         # => "xn--80aalb1aicli8a5i.xn--p1ai"
url.host                      # => "xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.normalized.host           # => "xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.origin                    # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.normalized.origin         # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai"
url.path                      # => "/foo"
url.normalized.path           # => "/foo"
url.without_scheme            # => "//xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"
url.normalized.without_scheme # => "//xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"
url.userinfo                  # => ""
url.normalized.userinfo       # => ""
url.user                      # => ""
url.normalized.user           # => ""
url.password                  # => ""
url.normalized.password       # => ""
url.valid?                    # => "true"
url.normalized.valid?         # => "true"
url.to_s                      # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"
url.normalized.to_s           # => "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"

url = Twingly::URL.parse("https://admin:correcthorsebatterystaple@example.com/")
url.scheme                    # => "https"
url.normalized.scheme         # => "https"
url.trd                       # => ""
url.normalized.trd            # => "www"
url.sld                       # => "example"
url.normalized.sld            # => "example"
url.tld                       # => "com"
url.normalized.tld            # => "com"
url.ttld                      # => "com"
url.normalized.ttld           # => "com"
url.domain                    # => "example.com"
url.normalized.domain         # => "example.com"
url.host                      # => "example.com"
url.normalized.host           # => "www.example.com"
url.origin                    # => "https://example.com"
url.normalized.origin         # => "https://www.example.com"
url.path                      # => "/"
url.normalized.path           # => "/"
url.without_scheme            # => "//admin:correcthorsebatterystaple@example.com/"
url.normalized.without_scheme # => "//admin:correcthorsebatterystaple@www.example.com/"
url.userinfo                  # => "admin:correcthorsebatterystaple"
url.normalized.userinfo       # => "admin:correcthorsebatterystaple"
url.user                      # => "admin"
url.normalized.user           # => "admin"
url.password                  # => "correcthorsebatterystaple"
url.normalized.password       # => "correcthorsebatterystaple"
url.valid?                    # => "true"
url.normalized.valid?         # => "true"
url.to_s                      # => "https://admin:correcthorsebatterystaple@example.com/"
url.normalized.to_s           # => "https://admin:correcthorsebatterystaple@www.example.com/"
```

### Dependencies

Only the gems listed in the [Gem Specification](https://github.com/twingly/twingly-url/blob/master/twingly-url.gemspec).

## Development

To inspect the [Public Suffix List], this handy command can be used (also works in projects that use `twingly-url` as an dependency).

    open $(bundle show public_suffix)/data/list.txt

[Public Suffix List]: https://github.com/weppos/publicsuffix-ruby

## Tests

Run tests with

    bundle exec rake

### Profiling

You can get some profiling by running

    cd profile/
    bundle
    bundle exec rake

Note that this isn't a benchmark, we're using [ruby-prof] which will slow things down.

## Release workflow

* Update the [examples] in this README if needed, generate the output with

        ruby examples/url.rb

* Bump the version in `lib/twingly/version.rb` in a commit, no need to push (the release task does that).

* Ensure you are signed in to RubyGems.org as [twingly][twingly-rubygems] with `gem signin`.

* Build and [publish](http://guides.rubygems.org/publishing/) the gem. This will create the proper tag in git, push the commit and tag and upload to RubyGems.

        bundle exec rake release

* Update the changelog with [GitHub Changelog Generator](https://github.com/skywinder/github-changelog-generator/) (`gem install github_changelog_generator` if you don't have it, set `CHANGELOG_GITHUB_TOKEN` to a personal access token to avoid rate limiting by GitHub). This command will update `CHANGELOG.md`. You need to commit and push manually.

        github_changelog_generator

[twingly-rubygems]: https://rubygems.org/profiles/twingly
[ruby-prof]: http://ruby-prof.rubyforge.org/
[examples]: examples/url.rb
