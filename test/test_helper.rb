require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda-context'

require 'twingly/url'
require 'twingly/url/hasher'
require 'twingly/url/normalizer'
require 'twingly/url/utilities'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
