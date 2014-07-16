require 'test_helper'

class UrlTest < Test::Unit::TestCase
  context ".parse" do
    should "not blow up for invalid url" do
      invalid_urls = %w(http://http http:/// http:// http:/ http: htttp a 1 ?)
      invalid_urls.each do |url|
        Twingly::URL.parse(url)
      end
    end
  end

  context ".validate" do
    should "return true for a valid url" do
      assert Twingly::URL.validate("http://blog.twingly.com/"), "Should be valid"
    end

    should "return false for a invalid url" do
      refute Twingly::URL.validate("http://"), "Should not be valid"
      refute Twingly::URL.validate("feedville.com,2007-06-19:/blends/16171"), "Should not be valid"
    end
  end
end
