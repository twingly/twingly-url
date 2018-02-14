# Change Log

## [v5.1.1](https://github.com/twingly/twingly-url/tree/v5.1.1) (2018-02-14)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v5.1.0...v5.1.1)

**Implemented enhancements:**

- Rework exceptions [\#31](https://github.com/twingly/twingly-url/issues/31)

**Merged pull requests:**

- Allow future patch versions of dependencies [\#118](https://github.com/twingly/twingly-url/pull/118) ([dentarg](https://github.com/dentarg))
- Update PublicSuffix and Addressable [\#117](https://github.com/twingly/twingly-url/pull/117) ([roback](https://github.com/roback))
- Use latest rubies on Travis CI [\#116](https://github.com/twingly/twingly-url/pull/116) ([dentarg](https://github.com/dentarg))
- Use latest rubies on Travis CI [\#115](https://github.com/twingly/twingly-url/pull/115) ([walro](https://github.com/walro))
- Use latest rubies on Travis CI [\#114](https://github.com/twingly/twingly-url/pull/114) ([dentarg](https://github.com/dentarg))
- Do not blow up on Addressable::IDNA::PunycodeBigOutput [\#113](https://github.com/twingly/twingly-url/pull/113) ([dentarg](https://github.com/dentarg))
- Bump Ruby versions tested on Travis CI [\#111](https://github.com/twingly/twingly-url/pull/111) ([dentarg](https://github.com/dentarg))
- Tag exceptions [\#106](https://github.com/twingly/twingly-url/pull/106) ([dentarg](https://github.com/dentarg))
- Switch to logical requires [\#103](https://github.com/twingly/twingly-url/pull/103) ([dentarg](https://github.com/dentarg))

## [v5.1.0](https://github.com/twingly/twingly-url/tree/v5.1.0) (2017-03-03)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v5.0.1...v5.1.0)

**Implemented enhancements:**

- Release a new version \(without idn-ruby\) [\#110](https://github.com/twingly/twingly-url/issues/110)
- Unfortunate require in Rakefile \(profile task\), affect specs [\#92](https://github.com/twingly/twingly-url/issues/92)
- JRuby compatibility \(drop libidn requirement\) [\#66](https://github.com/twingly/twingly-url/issues/66)

**Fixed bugs:**

- Dependencies not locked correctly [\#104](https://github.com/twingly/twingly-url/issues/104)
- twingly-url doesn't support IDNA2008, only IDNA2003 \(libidn\) [\#101](https://github.com/twingly/twingly-url/issues/101)

**Merged pull requests:**

- Test the latest Ruby releases [\#108](https://github.com/twingly/twingly-url/pull/108) ([dentarg](https://github.com/dentarg))
- Depend on addressable 2.5.0 and public\_suffix 2.0.3 [\#107](https://github.com/twingly/twingly-url/pull/107) ([dentarg](https://github.com/dentarg))
- Remove ruby-prof from dev dependencies [\#105](https://github.com/twingly/twingly-url/pull/105) ([dentarg](https://github.com/dentarg))
- Drop libidn [\#102](https://github.com/twingly/twingly-url/pull/102) ([dentarg](https://github.com/dentarg))

## [v5.0.1](https://github.com/twingly/twingly-url/tree/v5.0.1) (2016-09-19)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- "ArgumentError: invalid byte sequence in US-ASCII" when parsing the public suffix list [\#98](https://github.com/twingly/twingly-url/issues/98)

**Merged pull requests:**

- Make sure we always read PSL data as UTF-8 [\#99](https://github.com/twingly/twingly-url/pull/99) ([dentarg](https://github.com/dentarg))

## [v5.0.0](https://github.com/twingly/twingly-url/tree/v5.0.0) (2016-09-16)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v4.2.0...v5.0.0)

**Implemented enhancements:**

- License file [\#91](https://github.com/twingly/twingly-url/issues/91)
- Use PublicSuffix 2.0 [\#85](https://github.com/twingly/twingly-url/issues/85)
- Changelog [\#33](https://github.com/twingly/twingly-url/issues/33)

**Fixed bugs:**

- NormalizedURL\#to\_s returns punycode, other instance methods does not [\#89](https://github.com/twingly/twingly-url/issues/89)

**Merged pull requests:**

- DRY up to urls example [\#95](https://github.com/twingly/twingly-url/pull/95) ([jage](https://github.com/jage))
- Add changelog [\#93](https://github.com/twingly/twingly-url/pull/93) ([dentarg](https://github.com/dentarg))
- Ensure normalized IDNA domains return ASCII strings [\#90](https://github.com/twingly/twingly-url/pull/90) ([dentarg](https://github.com/dentarg))

## [v4.2.0](https://github.com/twingly/twingly-url/tree/v4.2.0) (2016-08-31)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v4.1.0...v4.2.0)

**Merged pull requests:**

- Add Twingly::URL\#ttld, "true TLD" getter [\#88](https://github.com/twingly/twingly-url/pull/88) ([dentarg](https://github.com/dentarg))
- Add example usage to README [\#86](https://github.com/twingly/twingly-url/pull/86) ([dentarg](https://github.com/dentarg))

## [v4.1.0](https://github.com/twingly/twingly-url/tree/v4.1.0) (2016-05-23)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v4.0.0...v4.1.0)

**Closed issues:**

- Expose addressable's \#userinfo [\#73](https://github.com/twingly/twingly-url/issues/73)

**Merged pull requests:**

- Expose userinfo, user and password [\#84](https://github.com/twingly/twingly-url/pull/84) ([jage](https://github.com/jage))

## [v4.0.0](https://github.com/twingly/twingly-url/tree/v4.0.0) (2016-02-03)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v3.0.2...v4.0.0)

**Implemented enhancements:**

- Make more methods private [\#60](https://github.com/twingly/twingly-url/issues/60)

**Fixed bugs:**

- domain, sld, trd \(maybe others\) can be nil [\#52](https://github.com/twingly/twingly-url/issues/52)

**Merged pull requests:**

- Temporary fix for UTF-8 bug in addressable [\#79](https://github.com/twingly/twingly-url/pull/79) ([roback](https://github.com/roback))
- No part of a URL should be nil [\#78](https://github.com/twingly/twingly-url/pull/78) ([roback](https://github.com/roback))
- The gem should load the version constant [\#75](https://github.com/twingly/twingly-url/pull/75) ([dentarg](https://github.com/dentarg))
- Make things private [\#69](https://github.com/twingly/twingly-url/pull/69) ([dentarg](https://github.com/dentarg))

## [v3.0.2](https://github.com/twingly/twingly-url/tree/v3.0.2) (2015-11-11)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v3.0.1...v3.0.2)

**Fixed bugs:**

- IDN::Idna::IdnaError: Output would be too large or too small [\#64](https://github.com/twingly/twingly-url/issues/64)

**Merged pull requests:**

- Rescue IDN::Idna::IdnaError [\#65](https://github.com/twingly/twingly-url/pull/65) ([dentarg](https://github.com/dentarg))

## [v3.0.1](https://github.com/twingly/twingly-url/tree/v3.0.1) (2015-11-11)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- Do not blow up on broken punycode URLs  [\#48](https://github.com/twingly/twingly-url/issues/48)

**Merged pull requests:**

- Improve punycode handling with libidn [\#63](https://github.com/twingly/twingly-url/pull/63) ([walro](https://github.com/walro))

## [v3.0.0](https://github.com/twingly/twingly-url/tree/v3.0.0) (2015-11-02)
[Full Changelog](https://github.com/twingly/twingly-url/compare/v2.0.0...v3.0.0)

**Implemented enhancements:**

- New major release [\#38](https://github.com/twingly/twingly-url/issues/38)

**Fixed bugs:**

- require bug [\#56](https://github.com/twingly/twingly-url/issues/56)
- \#valid? doesn't work for protocol-less urls [\#55](https://github.com/twingly/twingly-url/issues/55)
- Drop support for older Ruby versions [\#53](https://github.com/twingly/twingly-url/issues/53)

**Merged pull requests:**

- We support 2.2.x [\#59](https://github.com/twingly/twingly-url/pull/59) ([walro](https://github.com/walro))
- Fix "\#valid? doesn't work for protocol-less urls" [\#58](https://github.com/twingly/twingly-url/pull/58) ([walro](https://github.com/walro))
- Refactor requires [\#57](https://github.com/twingly/twingly-url/pull/57) ([dentarg](https://github.com/dentarg))

## [v2.0.0](https://github.com/twingly/twingly-url/tree/v2.0.0) (2015-10-26)
**Implemented enhancements:**

- Move lib/version.rb to lib/twingly/version.rb [\#50](https://github.com/twingly/twingly-url/issues/50)
- Prettier inspect output [\#43](https://github.com/twingly/twingly-url/issues/43)
- Return objects instead of strings [\#40](https://github.com/twingly/twingly-url/issues/40)
- Do not return nil [\#35](https://github.com/twingly/twingly-url/issues/35)
- Method to extract URLs from text without normalizing [\#34](https://github.com/twingly/twingly-url/issues/34)
- Turn is unmaintained [\#27](https://github.com/twingly/twingly-url/issues/27)
- Should normalize IDN properly [\#17](https://github.com/twingly/twingly-url/issues/17)
- Discrepancy with .NET normalization [\#12](https://github.com/twingly/twingly-url/issues/12)
- Capability for extracting origin part of an URL [\#11](https://github.com/twingly/twingly-url/issues/11)
- Always return normalized urls in lower case [\#8](https://github.com/twingly/twingly-url/issues/8)
- Make gem more general [\#6](https://github.com/twingly/twingly-url/issues/6)

**Fixed bugs:**

- Ensure proper behaviour for edge-case input data [\#45](https://github.com/twingly/twingly-url/issues/45)
- normalize method can't handle URLs with punycoded TLD [\#28](https://github.com/twingly/twingly-url/issues/28)
- Shoulda-context does not seem to work with Ruby 2.2 [\#26](https://github.com/twingly/twingly-url/issues/26)
- Digest is not threadsafe [\#20](https://github.com/twingly/twingly-url/issues/20)
- Should normalize IDN properly [\#17](https://github.com/twingly/twingly-url/issues/17)
- Blogspot.com normalization error [\#13](https://github.com/twingly/twingly-url/issues/13)
- Discrepancy with .NET normalization [\#12](https://github.com/twingly/twingly-url/issues/12)
- Crashes if only a protocol is provided [\#10](https://github.com/twingly/twingly-url/issues/10)
- Can not handle urls with international characters [\#2](https://github.com/twingly/twingly-url/issues/2)
- Add tests [\#1](https://github.com/twingly/twingly-url/issues/1)

**Closed issues:**

- Release 1.3.3 [\#22](https://github.com/twingly/twingly-url/issues/22)
- Encrypt HipChat API key in .travis.yml [\#16](https://github.com/twingly/twingly-url/issues/16)
- Always return normalized URLs with lower case scheme [\#9](https://github.com/twingly/twingly-url/issues/9)
- Add test for URL: feedville.com,2007-06-19:/blends/16171 [\#7](https://github.com/twingly/twingly-url/issues/7)
- Make repo public [\#5](https://github.com/twingly/twingly-url/issues/5)
- Add .ruby-version file? [\#4](https://github.com/twingly/twingly-url/issues/4)

**Merged pull requests:**

- Move version.rb to correct subdir [\#51](https://github.com/twingly/twingly-url/pull/51) ([jage](https://github.com/jage))
- Implement prettier \#inspect [\#47](https://github.com/twingly/twingly-url/pull/47) ([jage](https://github.com/jage))
- Work with Twingly::URL objects instead of strings [\#42](https://github.com/twingly/twingly-url/pull/42) ([twingly-mob](https://github.com/twingly-mob))
- New .extract\_url method which does not normalize [\#41](https://github.com/twingly/twingly-url/pull/41) ([twingly-mob](https://github.com/twingly-mob))
- Sync known behaviour with .NET [\#37](https://github.com/twingly/twingly-url/pull/37) ([roback](https://github.com/roback))
- Change from minitest to rspec [\#36](https://github.com/twingly/twingly-url/pull/36) ([roback](https://github.com/roback))
- Make sure Digest loading is thread-safe [\#32](https://github.com/twingly/twingly-url/pull/32) ([jage](https://github.com/jage))
- Ensure we have a tmp directory to dump result to [\#30](https://github.com/twingly/twingly-url/pull/30) ([walro](https://github.com/walro))
- Turn is unmaintained [\#29](https://github.com/twingly/twingly-url/pull/29) ([walro](https://github.com/walro))
- Downcase URLs in normalization [\#23](https://github.com/twingly/twingly-url/pull/23) ([jage](https://github.com/jage))
- Twingly::URL::Utilities.remove\_scheme [\#21](https://github.com/twingly/twingly-url/pull/21) ([jage](https://github.com/jage))
- Fix "gem build" warnings [\#19](https://github.com/twingly/twingly-url/pull/19) ([dentarg](https://github.com/dentarg))
- Rename gem to twingly-url [\#15](https://github.com/twingly/twingly-url/pull/15) ([jage](https://github.com/jage))
- Don't add www. to blogspot [\#14](https://github.com/twingly/twingly-url/pull/14) ([jage](https://github.com/jage))
- Tests [\#3](https://github.com/twingly/twingly-url/pull/3) ([jage](https://github.com/jage))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*