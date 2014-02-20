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

    should "handle URL with ] in it" do
      url = "http://www.iwaseki.co.jp/cgi/yybbs/yybbs.cgi/%DEuropean]buy"
      assert @normalizer.normalize(url)
    end

    should "handle URL with reference to another URL in it" do
      url = "http://news.google.com/news/url?sa=t&fd=R&usg=AFQjCNGc4A_sfGS6fMMqggiK_8h6yk2miw&url=http:%20%20%20//fansided.com/2013/08/02/nike-decides-to-drop-milwaukee-brewers-ryan-braun"
      assert @normalizer.normalize(url)
    end

    should "handle URL with umlauts in host" do
      url = "http://www.åäö.se/"
      assert_equal [url], @normalizer.normalize(url)
    end

    should "handle URL with umlauts in path" do
      url = "http://www.aoo.se/öö"
      assert_equal [url], @normalizer.normalize(url)
    end

    should "should not blow up when there's no URL in the text" do
      url = "Just some text"
      assert @normalizer.normalize(url)
    end

    should "should not create URLs for normal words" do
      url = "This is, just, some words. Yay!"
      assert_equal [], @normalizer.normalize(url)
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

    should "be able to normalize url without protocol" do
      url = "www.twingly.com/"
      result = @normalizer.normalize_url(url)

      assert_equal "http://www.twingly.com/", result
    end

    should "not return broken URLs" do
      url = "http://www.twingly."
      result = @normalizer.normalize_url(url)

      assert_equal nil, result
    end
  end
end
