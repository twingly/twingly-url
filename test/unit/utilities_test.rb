require 'test_helper'

class TestUtilities < Minitest::Test
  context ".normalize" do
    should "not remove scheme from non HTTP(S) URLs" do
      url = 'gopher://www.duh.se/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal 'gopher://www.duh.se/', result
    end

    should "remove scheme from mixed case HTTP URL" do
      url = 'HttP://www.duh.se/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//www.duh.se/', result
    end

    should "remove scheme from mixed case HTTPS URL" do
      url = 'hTTpS://www.duh.se/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//www.duh.se/', result
    end

    should "remove scheme from lowercase HTTP URL" do
      url = 'http://www.duh.se/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//www.duh.se/', result
    end

    should "remove scheme from lowercase HTTPS URL" do
      url = 'https://www.duh.se/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//www.duh.se/', result
    end

    should "remove scheme from uppercase HTTP URL" do
      url = 'HTTP://WWW.DUH.SE/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//WWW.DUH.SE/', result
    end

    should "remove scheme from uppercase HTTPS URL" do
      url = 'HTTPS://WWW.DUH.SE/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//WWW.DUH.SE/', result
    end

    should "remove scheme from URL with non ASCII characters" do
      url = 'http://www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα', result
    end

    should "only remove scheme from HTTP URL" do
      url = 'http://feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml', result
    end

    should "only remove scheme from HTTPS URL" do
      url = 'https://feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal '//feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss', result
    end

    should "not remove scheme from non HTTP(S) URLs with parameter" do
      url = 'ftp://ftp.example.com/?url=https://www.example.com/'

      result = Twingly::URL::Utilities.remove_scheme(url)
      assert_equal 'ftp://ftp.example.com/?url=https://www.example.com/', result
    end
  end
end
