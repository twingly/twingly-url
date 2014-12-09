require 'test_helper'

class TestUtilities < MiniTest::Unit::TestCase
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
  end
end
