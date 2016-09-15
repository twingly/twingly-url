require "bundler/setup"
require_relative "../lib/twingly/url"

def print_url_details(url_as_string)
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
end

puts "require \"twingly/url\""

puts

print_url_details("http://www.twingly.co.uk/search")

puts

print_url_details("http://räksmörgås.макдональдс.рф/foo")

puts

print_url_details("http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo")

puts

print_url_details("https://admin:correcthorsebatterystaple@example.com/")
