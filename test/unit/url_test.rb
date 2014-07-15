require 'test_helper'

class UrlTest < Test::Unit::TestCase
  context ".validate" do
    should "return true for a valid url" do
      assert Twingly::URL.validate("http://blog.twingly.com/"), "Should be valid"
    end

    should "return false for a invalid url" do
      refute Twingly::URL.validate("http://"), "Should not be valid"
    end
  end
end
