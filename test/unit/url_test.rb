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

    should "should return false for non-http and https" do
      invalid_urls = %w(ftp://blog.twingly.com/ blablahttp://blog.twingly.com/)
      invalid_urls.each do |url|
        refute Twingly::URL.parse(url).valid?, "Should not be valid"
      end
    end

    should "should return true for http and https" do
      valid_urls = %w(http://blog.twingly.com/ hTTP://blog.twingly.com/ https://blog.twingly.com)
      valid_urls.each do |url|
        assert Twingly::URL.parse(url).valid?, "Should be valid"
      end
    end
  end
end
