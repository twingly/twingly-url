require 'test_helper'

class NormalizerTest < Test::Unit::TestCase
  context ".normalize" do
    setup do
      @normalizer = Twingly::URL::Normalizer
    end

    should "accept a String" do
      assert @normalizer.normalize("")
    end

    should "accept an Array" do
      assert @normalizer.normalize([])
    end
  end

  context ".extract_urls" do
    setup do
      @normalizer = Twingly::URL::Normalizer
    end

    should "detect two urls in a String" do
      urls = "http://blog.twingly.com/ http://twingly.com/"
      response = @normalizer.extract_urls(urls)

      response.size.must_equal 2
    end

    should "detect two urls in an Array" do
      urls = %w(http://blog.twingly.com/ http://twingly.com/)
      response = @normalizer.extract_urls(urls)

      response.size.must_equal 2
    end

    should "return an Array" do
      response = @normalizer.extract_urls(nil)

      response.must_be_instance_of Array
    end
  end

  context ".normalize_url" do
    setup do
      @normalizer = Twingly::URL::Normalizer
    end

    should "add www if host is missing a subdomain" do
      url = "http://twingly.com/"
      result = @normalizer.normalize_url(url)

      assert_equal "http://www.twingly.com/", result
    end

    should "not add www if the host has a subdomain" do
      url = "http://blog.twingly.com/"
      result = @normalizer.normalize_url(url)

      assert_equal "http://blog.twingly.com/", result
    end

    should "keep www if the host already has it" do
      url = "http://www.twingly.com/"
      result = @normalizer.normalize_url(url)

      assert_equal "http://www.twingly.com/", result
    end
  end
end
