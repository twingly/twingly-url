require "bundler/setup"
require_relative "../lib/twingly/url"

url_as_string = "http://www.twingly.co.uk/search"
url = Twingly::URL.parse(url_as_string)

puts "require \"twingly/url\""

puts

puts "url = Twingly::URL.parse(\"#{url_as_string}\")"
puts "url.scheme              # => \"#{url.scheme}\""
puts "url.trd                 # => \"#{url.trd}\""
puts "url.sld                 # => \"#{url.sld}\""
puts "url.tld                 # => \"#{url.tld}\""
puts "url.ttld                # => \"#{url.ttld}\""
puts "url.domain              # => \"#{url.domain}\""
puts "url.host                # => \"#{url.host}\""
puts "url.origin              # => \"#{url.origin}\""
puts "url.path                # => \"#{url.path}\""
puts "url.without_scheme      # => \"#{url.without_scheme}\""
puts "url.valid?              # => \"#{url.valid?}\""

puts

url_as_string = "https://admin:correcthorsebatterystaple@example.com/"
url = Twingly::URL.parse(url_as_string)

puts "url = Twingly::URL.parse(\"#{url_as_string}\")"
puts "url.scheme              # => \"#{url.scheme}\""
puts "url.trd                 # => \"#{url.trd}\""
puts "url.sld                 # => \"#{url.sld}\""
puts "url.tld                 # => \"#{url.tld}\""
puts "url.ttld                # => \"#{url.ttld}\""
puts "url.domain              # => \"#{url.domain}\""
puts "url.host                # => \"#{url.host}\""
puts "url.origin              # => \"#{url.origin}\""
puts "url.path                # => \"#{url.path}\""
puts "url.without_scheme      # => \"#{url.without_scheme}\""
puts "url.userinfo            # => \"#{url.userinfo}\""
puts "url.user                # => \"#{url.user}\""
puts "url.password            # => \"#{url.password}\""
puts "url.valid?              # => \"#{url.valid?}\""
