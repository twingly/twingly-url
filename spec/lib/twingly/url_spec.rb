require "spec_helper"

require "twingly/url"

def invalid_urls
  [
    "http://http",
    "http:///",
    "http:/",
    "http:",
    "htttp",
    "http://",
    "a",
    "1",
    "?",
    123,
    nil,
    false,
    "",
    //,
    "feedville.com,2007-06-19:/blends/16171",
    "ftp://blog.twingly.com/",
    "blablahttp://blog.twingly.com/",
    "gopher://blog.twingly.com/",
    "\n",
    "//www.twingly.com/",
  ]
end

def valid_urls
  [
    "http://blog.twingly.com/",
    "http://blOg.tWingly.coM/",
    "hTTP://blog.twingly.com/",
    "https://blog.twingly.com",
    "http://3.bp.blogspot.com/_lRbEHeizXlQ/Sf4RdEqCqhI/AAAAAAAAAAw/Pl8nGPsyhXc/s1600-h/images[4].jpg",
  ]
end

describe Twingly::URL do
  let(:test_url) do
    "http://www.blog.twingly.co.uk/2015/07/01/language-detection-changes/"
  end
  let(:url) { described_class.parse(test_url) }

  describe ".parse" do
    subject { url }

    it { is_expected.to be_a(Twingly::URL) }

    context "when given valid urls" do
      valid_urls.each do |valid_url|
        it "does not ruin the url \"#{valid_url}\"" do
          expect(described_class.parse(valid_url).to_s).to eq(valid_url)
        end
      end
    end

    context "when given bad input" do
      invalid_urls.each do |invalid_url|
        it "returns a NullURL for \"#{invalid_url}\"" do
          actual = described_class.parse(invalid_url)
          expect(actual).to be_a(Twingly::URL::NullURL)
        end
      end
    end

    context "when given badly encoded input" do
      let(:badly_encoded_url) { "http://abc.se/öあ\x81b\xE3" }
      let(:expected)          { "http://abc.se/öあ\uFFFDb\uFFFD" }
      let(:actual)            { described_class.parse(badly_encoded_url) }

      it "will replace badly encoded characters with unicode replacement character (U+FFFD)" do
        expect(actual.to_s).to eq(expected)
      end
    end

    context "when given ASCII input" do
      let(:ascii_url) { "http://www.twingly.com/öあ".force_encoding("ASCII-8BIT") }
      let(:expected)  { "http://www.twingly.com/öあ" }
      let(:actual)    { described_class.parse(ascii_url).to_s }

      it "can handle it but returns UTF-8" do
        expect(actual).to eq(expected)
      end
    end

    context "with url containing starting and trailing new lines" do
      let(:test_url) { "\nhttp://www.twingly.com/blog-data/\r\n" }
      let(:expected) { "http://www.twingly.com/blog-data/" }

      it { is_expected.to eq(expected) }
    end

    context "with url containing starting and trailing whitespaces" do
      let(:test_url) { "   http://www.twingly.com/blog-data/     " }
      let(:expected) { "http://www.twingly.com/blog-data/" }

      it { is_expected.to eq(expected) }
    end

    context "with url containing both newlines and whitespaces" do
      let(:test_url) { "  \n\r   https://anniaksa.wordpress.com/2014/05/19/privy-digging-blogg100/   \r   \n   " }
      let(:expected) { "https://anniaksa.wordpress.com/2014/05/19/privy-digging-blogg100/" }

      it { is_expected.to eq(expected) }
    end
  end

  describe ".internal_parse" do
    context "when given nil" do
      it "raises an error" do
        expect { described_class.internal_parse(nil) }.to raise_error(Twingly::URL::Error::ParseError)
      end
    end
  end

  describe "#initialize" do
    context "when given input parameters of wrong types" do
      it "raises an error" do
        expect { described_class.new("a", "b") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#scheme" do
    subject { url.scheme }
    it { is_expected.to eq("http") }
  end

  describe "#trd" do
    subject { url.trd }
    it { is_expected.to eq("www.blog") }
  end

  describe "#sld" do
    subject { url.sld }
    it { is_expected.to eq("twingly") }
  end

  describe "#tld" do
    subject { url.tld }
    it { is_expected.to eq("co.uk") }
  end

  describe "#domain" do
    subject { url.domain }
    it { is_expected.to eq("twingly.co.uk") }
  end

  describe "#host" do
    subject { url.host }
    it { is_expected.to eq("www.blog.twingly.co.uk") }
  end

  describe "#origin" do
    subject { url.origin }
    it { is_expected.to eq("http://www.blog.twingly.co.uk") }
  end

  describe "#path" do
    subject { url.path }
    it { is_expected.to eq("/2015/07/01/language-detection-changes/") }
  end

  describe "#normalized_path" do
    subject { url.normalized_path }
    it { is_expected.to eq("/2015/07/01/language-detection-changes") }
  end

  describe "#normalized_scheme" do
    subject { url.normalized_scheme }
    it { is_expected.to eq("http") }
  end

  describe "#normalized_host" do
    subject { url.normalized_host }
    it { is_expected.to eq("www.blog.twingly.co.uk") }
  end

  describe "#valid?" do
    invalid_urls.each do |invalid_url|
      it "returns false for an invalid URL \"#{invalid_url}\"" do
        expect(described_class.parse(invalid_url).valid?).to be false
      end
    end

    valid_urls.each do |valid_url|
      it "returns true for the valid url \"#{valid_url}\"" do
        expect(described_class.parse(valid_url).valid?).to be true
      end
    end

    context "when given nil input" do
      it "it returns false" do
        expect(described_class.parse(nil).valid?).to be false
      end
    end
  end

  describe "#normalized" do
    subject { described_class.parse(url).normalized.to_s }

    context "adds www if host is missing a subdomain" do
      let(:url)      { "http://twingly.com/" }
      let(:expected) { "http://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "does not add www if the host has a subdomain" do
      let(:url) { "http://blog.twingly.com/" }

      it { is_expected.to eq(url) }
    end

    context "does not remove www if the host has a subdomain" do
      let(:url) { "http://www.blog.twingly.com/" }

      it { is_expected.to eq(url) }
    end

    context "keeps www if the host already has it" do
      let(:url) { "http://www.twingly.com/" }

      it { is_expected.to eq(url) }
    end

    context "ensures that path starts with slash" do
      let(:url)      { "http://www.twingly.com" }
      let(:expected) { "http://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "ensures that path only starts with single slash" do
      let(:url)      { "http://www.twingly.com//" }
      let(:expected) { "http://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "removes trailing slash from end of path unless path becomes empty" do
      let(:url)      { "http://www.twingly.com/blog-data/" }
      let(:expected) { "http://www.twingly.com/blog-data" }

      it { is_expected.to eq(expected) }
    end

    context "does not remove whitespaces from middle of path" do
      let(:url)      { "http://www.twingly.com/blo g-data/" }
      let(:expected) { "http://www.twingly.com/blo g-data" }

      it { is_expected.to eq(expected) }
    end

    context "is able to normalize a url with double slash in path" do
      let(:url)      { "www.twingly.com/path//" }
      let(:expected) { "http://www.twingly.com/path" }

      it { is_expected.to eq(expected) }
    end

    context "is able to normalize a url without protocol" do
      let(:url)      { "www.twingly.com/" }
      let(:expected) { "http://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "does not return broken URLs" do
      let(:url)      { "http://www.twingly." }
      let(:expected) { "" }

      it { is_expected.to eq(expected) }
    end

    context "oddly enough, does not alter URLs with consecutive dots" do
      let(:url) { "http://www..twingly..com/" }

      it { is_expected.to eq(url) }
    end

    context "does not add www. to blogspot URLs" do
      let(:url) { "http://jlchen1026.blogspot.com/" }

      it { is_expected.to eq(url) }
    end

    context "removes www. from blogspot URLs" do
      let(:url)      { "http://www.jlchen1026.blogspot.com/" }
      let(:expected) { "http://jlchen1026.blogspot.com/" }

      it { is_expected.to eq(expected) }
    end

    context "rewrites blogspot TLDs to .com" do
      let(:url)      { "http://WWW.jlchen1026.blogspot.CO.UK/" }
      let(:expected) { "http://jlchen1026.blogspot.com/" }

      it { is_expected.to eq(expected) }
    end

    context "downcases the protocol" do
      let(:url)      { "HTTPS://www.twingly.com/" }
      let(:expected) { "https://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "downcases the domain" do
      let(:url)      { "http://WWW.TWINGLY.COM/" }
      let(:expected) { "http://www.twingly.com/" }

      it { is_expected.to eq(expected) }
    end

    context "does not downcase the path" do
      let(:url) { "http://www.twingly.com/PaTH" }

      it { is_expected.to eq(url) }
    end

    context "does not downcase fragment" do
      let(:url) { "http://www.twingly.com/#FRAGment" }

      it { is_expected.to eq(url) }
    end

    context "handles URL with ] in it" do
      let(:url) { "http://www.iwaseki.co.jp/cgi/yybbs/yybbs.cgi/%DEuropean]buy" }

      it { is_expected.to eq(url) }
    end

    context "handles URL with reference to another URL in it" do
      let(:url) { "http://news.google.com/news/url?sa=t&fd=R&usg=AFQjCNGc4A_sfGS6fMMqggiK_8h6yk2miw&url=http:%20%20%20//fansided.com/2013/08/02/nike-decides-to-drop-milwaukee-brewers-ryan-braun" }

      it { is_expected.to eq(url) }
    end

    context "handles URL with umlauts in host" do
      let(:url)      { "http://www.åäö.se/" }
      let(:expected) { "http://www.xn--4cab6c.se/" }

      it { is_expected.to eq(expected) }
    end

    context "handles URL with umlauts in path" do
      let(:url) { "http://www.aoo.se/öö" }

      it { is_expected.to eq(url) }
    end

    context "handles URL with punycoded SLD" do
      let(:url) { "http://www.xn--4cab6c.se/" }

      it { is_expected.to eq(url) }
    end

    context "handles URL with punycoded TLD" do
      let(:url)      { "http://example.xn--p1ai/" }
      let(:expected) { "http://www.example.xn--p1ai/" }

      it { is_expected.to eq(expected) }
    end

    context "converts to a punycoded URL" do
      let(:url)      { "скраповыймир.рф" }
      let(:expected) { "http://www.xn--80aesdcplhhhb0k.xn--p1ai/" }

      it { is_expected.to eq(expected) }
    end

    context "does not blow up when there's no URL in the text" do
      let(:url)      { "Just some text" }
      let(:expected) { "" }

      it { is_expected.to eq(expected) }
    end
  end

  describe "#without_scheme" do
    subject { described_class.parse(url).without_scheme }

    context "removes scheme from mixed case HTTP URL" do
      let(:url)      { "HttP://www.duh.se/" }
      let(:expected) { "//www.duh.se/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from mixed case HTTPS URL" do
      let(:url)      { "hTTpS://www.duh.se/" }
      let(:expected) { "//www.duh.se/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from lowercase HTTP URL" do
      let(:url)      { "http://www.duh.se/" }
      let(:expected) { "//www.duh.se/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from lowercase HTTPS URL" do
      let(:url)      { "https://www.duh.se/" }
      let(:expected) { "//www.duh.se/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from uppercase HTTP URL" do
      let(:url)      { "HTTP://WWW.DUH.SE/" }
      let(:expected) { "//WWW.DUH.SE/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from uppercase HTTPS URL" do
      let(:url)      { "HTTPS://WWW.DUH.SE/" }
      let(:expected) { "//WWW.DUH.SE/" }

      it { is_expected.to eq(expected) }
    end

    context "removes scheme from URL with non ASCII characters" do
      let(:url)      { "http://www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα" }
      let(:expected) { "//www.thecloset.gr/people/bloggers-pick-ιωάννα-τσιγαρίδα" }

      it { is_expected.to eq(expected) }
    end

    context "only removes scheme from HTTP URL" do
      let(:url)      { "http://feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml" }
      let(:expected) { "//feedjira.herokuapp.com/?url=http://developer.twingly.com/feed.xml" }

      it { is_expected.to eq(expected) }
    end

    context "only removes scheme from HTTPS URL" do
      let(:url)      { "https://feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss" }
      let(:expected) { "//feedjira.herokuapp.com/?url=https://signalvnoise.com/posts.rss" }

      it { is_expected.to eq(expected) }
    end
  end

  describe "#to_s" do
    subject { url.to_s }
    it { is_expected.to eq(test_url) }
  end

  describe "comparable methods" do
    let(:a) { "http://a.com" }
    let(:b) { "http://b.com" }

    describe "#<=>" do
      let(:test_urls) { [b, a, b, a, a] }

      subject do
        test_urls.map { |url| described_class.parse(url) }.sort.map(&:to_s)
      end

      it { is_expected.to eq(test_urls.sort) }
    end

    describe "#==" do
      context "when parsing the same URLs" do
        subject { described_class.parse(a) == described_class.parse(a) }
        it { is_expected.to be(true) }
      end

      context "when parsing different URLs" do
        subject { described_class.parse(a) == described_class.parse(b) }
        it { is_expected.to be(false) }
      end
    end

    describe "#===" do
      context "when parsing the same URLs" do
        subject { described_class.parse(a) === described_class.parse(a) }
        it { is_expected.to be(true) }
      end

      context "when parsing different URLs" do
        subject { described_class.parse(a) === described_class.parse(b) }
        it { is_expected.to be(false) }
      end
    end

    context "with invalid and valid URLs" do
      let(:test_urls) { [b, "", a] }

      subject do
        test_urls.map { |url| described_class.parse(url) }.sort.map(&:to_s)
      end

      it { is_expected.to eq(test_urls.sort) }
    end
  end

  describe "#inspect" do
    let(:url_object) { described_class.parse(url) }
    subject { url_object.inspect }

    it { is_expected.to include(url_object.to_s) }
  end
end
