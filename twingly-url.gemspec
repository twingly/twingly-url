# encoding: utf-8

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "twingly-url"
  s.version     = Twingly::URL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johan Eckerström"]
  s.email       = ["johan.eckerstrom@twingly.com"]
  s.homepage    = "http://github.com/twingly/twingly-url-normalizer"
  s.summary     = "Ruby library for URL handling"
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency "addressable"
  s.add_dependency "public_suffix", "~> 1.4.0"

  s.add_development_dependency "turn"
  s.add_development_dependency "rake"
  s.add_development_dependency "shoulda-context"
  s.add_development_dependency "ruby-prof"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
end
