require "spec_helper"

describe Twingly::URL::Utilities do
  describe ".normalize" do
    it "does not remove scheme from non HTTP(S) URLs" do
      url = "gopher://www.duh.se/"

      expect(described_class.remove_scheme(url)).to eq(url)
    end

    it "removes scheme from mixed case HTTP URL" do
      url = "HttP://www.duh.se/"
      expected = "//www.duh.se/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from mixed case HTTPS URL" do
      url = "hTTpS://www.duh.se/"
      expected = "//www.duh.se/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from lowercase HTTP URL" do
      url = "http://www.duh.se/"
      expected = "//www.duh.se/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from lowercase HTTPS URL" do
      url = "https://www.duh.se/"
      expected = "//www.duh.se/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from uppercase HTTP URL" do
      url = "HTTP://WWW.DUH.SE/"
      expected = "//WWW.DUH.SE/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from uppercase HTTPS URL" do
      url = "HTTPS://WWW.DUH.SE/"
      expected = "//WWW.DUH.SE/"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "removes scheme from URL with non ASCII characters" do
      url = "http://www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα"
      expected = "//www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "only removes scheme from HTTP URL" do
      url = "http://feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml"
      expected = "//feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "only removes scheme from HTTPS URL" do
      url = "https://feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss"
      expected = "//feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss"

      expect(described_class.remove_scheme(url)).to eq(expected)
    end

    it "does not remove scheme from non HTTP(S) URLs with parameter" do
      url = "ftp://ftp.example.com/?url=https://www.example.com/"

      expect(described_class.remove_scheme(url)).to eq(url)
    end
  end
end
