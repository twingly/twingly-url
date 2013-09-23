# twingly-url-normalizer

Ruby gem for URL normalization

## Example

```
[5] pry(main)> Twingly::URL::Normalizer.normalize('aoeu')
=> []
[6] pry(main)> Twingly::URL::Normalizer.normalize('duh.se')
=> ["http://www.duh.se/"]
```
