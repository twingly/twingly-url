require "bundler/setup"
require_relative "../lib/twingly/url"

def print_url_details(url_as_string)
  url = Twingly::URL.parse(url_as_string)

  puts "url = Twingly::URL.parse(\"#{url_as_string}\")"
  puts "url.scheme                    # => \"#{url.scheme}\""
  puts "url.normalized.scheme         # => \"#{url.normalized.scheme}\""
  puts "url.trd                       # => \"#{url.trd}\""
  puts "url.normalized.trd            # => \"#{url.normalized.trd}\""
  puts "url.sld                       # => \"#{url.sld}\""
  puts "url.normalized.sld            # => \"#{url.normalized.sld}\""
  puts "url.tld                       # => \"#{url.tld}\""
  puts "url.normalized.tld            # => \"#{url.normalized.tld}\""
  puts "url.ttld                      # => \"#{url.ttld}\""
  puts "url.normalized.ttld           # => \"#{url.normalized.ttld}\""
  puts "url.domain                    # => \"#{url.domain}\""
  puts "url.normalized.domain         # => \"#{url.normalized.domain}\""
  puts "url.host                      # => \"#{url.host}\""
  puts "url.normalized.host           # => \"#{url.normalized.host}\""
  puts "url.origin                    # => \"#{url.origin}\""
  puts "url.normalized.origin         # => \"#{url.normalized.origin}\""
  puts "url.path                      # => \"#{url.path}\""
  puts "url.normalized.path           # => \"#{url.normalized.path}\""
  puts "url.without_scheme            # => \"#{url.without_scheme}\""
  puts "url.normalized.without_scheme # => \"#{url.normalized.without_scheme}\""
  puts "url.userinfo                  # => \"#{url.userinfo}\""
  puts "url.normalized.userinfo       # => \"#{url.normalized.userinfo}\""
  puts "url.user                      # => \"#{url.user}\""
  puts "url.normalized.user           # => \"#{url.normalized.user}\""
  puts "url.password                  # => \"#{url.password}\""
  puts "url.normalized.password       # => \"#{url.normalized.password}\""
  puts "url.valid?                    # => \"#{url.valid?}\""
  puts "url.normalized.valid?         # => \"#{url.normalized.valid?}\""
  puts "url.to_s                      # => \"#{url.to_s}\""
  puts "url.normalized.to_s           # => \"#{url.normalized.to_s}\""
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
