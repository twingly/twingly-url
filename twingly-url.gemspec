require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "twingly-url"
  s.version     = Twingly::URL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Twingly AB"]
  s.email       = ["support@twingly.com"]
  s.homepage    = "http://github.com/twingly/twingly-url"
  s.summary     = "Ruby library for URL handling"
  s.description = "Twingly URL tools"
  s.license     = "MIT"
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "addressable", "~> 2"
  s.add_dependency "public_suffix", "~> 1.4"

  s.add_development_dependency "turn", "~> 0"
  s.add_development_dependency "rake", "~> 10"
  s.add_development_dependency "shoulda-context", "~> 1"
  s.add_development_dependency "ruby-prof", "~> 0"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
end
