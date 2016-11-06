require File.expand_path('../lib/twingly/version', __FILE__)

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
  s.required_ruby_version = "~> 2.2"

  s.add_dependency "addressable", "= 2.4.0"
  s.add_dependency "public_suffix", "= 2.0.2"

  s.add_development_dependency "rake", "~> 10"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "pry"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
end
