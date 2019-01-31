# frozen_string_literal: true

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
    "http://xn--t...-/",
    "http://xn--...-",
    "leather beltsbelts for menleather beltmens beltsleather belts for menmens beltbelt bucklesblack l...",
    "https//.com",
    "http://xxx@.com/",
    "http://...com",
    "http://.ly/xxx",
    "http://.com.my/",
    "http://.net",
    "http://.com.",
    "http://.gl/xxx",
    "http://.twingly.com/",
    "http://www.twingly.",

    # Test that we can handle upstream bug in Addressable, references:
    # https://github.com/twingly/twingly-url/issues/62
    # https://github.com/sporkmonger/addressable/issues/224
    "http://some_site.net%C2",
    "http://+%D5d.some_site.net",

    # Triggers Addressable::IDNA::PunycodeBigOutput
    "http://40world-many.ru&amp;passwd=pUXFGc0LS5&amp;subject=%D0%B1%D0%B0%D0%BB%D0%B0%D0%BD%D1%81%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0+%D0%BA%D0%B0%D1%80%D0%B4%D0%B0%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE+%D0%B2%D0%B0%D0%BB%D0%B0&amp;commit=Predict&amp;complex=true&amp;complex=false&amp;membrane=false&amp;coil=false&amp;msa_control=all&amp;secStructPred=true&amp;secStructPred=false&amp;falseRate=5&amp;output=opnone&amp;modeller=&amp;seqalign=yes&amp;database=PfamA&amp;eval=0.01&amp;iterations=5&amp;domssea=yes&amp;secpro=yes&amp;pp=yes",
  ]
end

def valid_urls
  [
    "http://blog.twingly.com/",
    "http://blOg.tWingly.coM/",
    "hTTP://blog.twingly.com/",
    "https://blog.twingly.com",
    "http://3.bp.blogspot.com/_lRbEHeizXlQ/Sf4RdEqCqhI/AAAAAAAAAAw/Pl8nGPsyhXc/s1600-h/images[4].jpg",
    "http://xn--zckp1cyg1.sblo.jp/",
    "http://eleven.se/mason-pearson-pocket-bristle-nylon-dark-ruby-20683.html&gclid=CjwKEAiAvPGxBRCH3YCgpdbCtmYSJABqHRVw1ZLaelwjepCihWgKkoqgl2t7k0J6J8I1IFp3GYZmKxoCc-nw_wcB?gclid=CjwKEAiAvPGxBRCH3YCgpdbCtmYSJABqHRVw1ZLaelwjepCihWgKkoqgl2t7k0J6J8I1IFp3GYZmKxoCc-nw_wcB",
    "http://xn--rksmrgs-5wao1o.josefsson.org/",
    "http://räksmörgås.josefßon.org",
    "http://user:password@blog.twingly.com/",
    "http://:@blog.twingly.com/",
    "https://www.foo.ایران.ir/bar",
    "https://www.foo.xn--mgba3a4f16a.ir/bar",
    "http://AcinusFallumTrompetumNullunCreditumVisumEstAtCuadLongumEtCefallumEst.com",
  ]
end

describe Twingly::URL do
  let(:unicode_idn_test_url) do
    "http://räksmörgås.макдональдс.рф/foo"
  end

  let(:ascii_idn_test_url) do
    "http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai/foo"
  end

  let(:test_url) do
    "http://www.blog.twingly.co.uk/2015/07/01/language-detection-changes/"
  end
  let(:url) { described_class.parse(test_url) }

  describe ".parse" do
    subject { url }

    it { is_expected.to be_a(Twingly::URL) }

    context "when re-reraising errors" do
      let(:some_exception) { Exception }

      before do
        allow(described_class)
          .to receive(:internal_parse)
          .and_raise(some_exception)
      end

      it "always tags the error" do
        expect { subject }.to raise_error do |error|
          aggregate_failures do
            expect(error).to be_instance_of(some_exception)
            expect(error).to be_kind_of(Twingly::URL::Error)
          end
        end
      end
    end

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
      let(:ascii_url) { "http://www.twingly.com/öあ".dup.force_encoding("ASCII-8BIT") }
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
    context "when called from the outside" do
      it "raises an error" do
        expect { described_class.internal_parse("a") }.
          to raise_error(NoMethodError, /private method `internal_parse' called for/)
      end
    end
  end

  describe ".new" do
    context "when called from the outside" do
      it "raises an error" do
        expect { described_class.new("a", "b") }.
          to raise_error(NoMethodError, /private method `new' called for/)
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

    context "when the url contains no trd" do
      let(:test_url){ "http://twingly.com" }
      it { is_expected.to eq("") }
    end

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("räksmörgås") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--rksmrgs-5wao1o") }
      end
    end
  end

  describe "#sld" do
    subject { url.sld }
    it { is_expected.to eq("twingly") }

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("макдональдс") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--80aalb1aicli8a5i") }
      end
    end
  end

  describe "#tld" do
    subject { url.tld }
    it { is_expected.to eq("co.uk") }

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("рф") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--p1ai") }
      end

      describe "punycoded TLD with multiple levels" do
        let(:test_url) { "https://foo.sande.xn--mre-og-romsdal-qqb.no/bar" }
        it { is_expected.to eq("sande.xn--mre-og-romsdal-qqb.no") }
      end
    end
  end

  describe "#ttld" do
    subject { url.ttld }
    it { is_expected.to eq("uk") }

    context "when the TLD is just one level" do
      let(:test_url){ "http://twingly.com" }

      it { is_expected.to eq("com") }
    end

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("рф") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--p1ai") }
      end
    end
  end

  describe "#domain" do
    subject { url.domain }
    it { is_expected.to eq("twingly.co.uk") }

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("макдональдс.рф") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--80aalb1aicli8a5i.xn--p1ai") }
      end
    end
  end

  describe "#host" do
    subject { url.host }
    it { is_expected.to eq("www.blog.twingly.co.uk") }

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("räksmörgås.макдональдс.рф") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai") }
      end
    end
  end

  describe "#origin" do
    subject { url.origin }
    it { is_expected.to eq("http://www.blog.twingly.co.uk") }

    context "internationalized domain name" do
      describe "given in Unicode" do
        let(:test_url) { unicode_idn_test_url }
        it { is_expected.to eq("http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai") }
      end

      describe "given in ASCII" do
        let(:test_url) { ascii_idn_test_url }
        it { is_expected.to eq("http://xn--rksmrgs-5wao1o.xn--80aalb1aicli8a5i.xn--p1ai") }
      end
    end
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
    context "when given valid urls" do
      valid_urls.each do |valid_url|
        it "does not raise an error for \"#{valid_url}\"" do
          actual = described_class.parse(valid_url).normalized
          expect(actual).to be_a(Twingly::URL)
        end
      end
    end

    context "when given bad input" do
      invalid_urls.each do |invalid_url|
        it "returns NullURL for \"#{invalid_url}\"" do
          actual = described_class.parse(invalid_url).normalized
          expect(actual).to be_a(Twingly::URL::NullURL)
        end
      end
    end

    subject { described_class.parse(url).normalized.to_s }

    context "when given IDN URL with the domain \"straße.de\"" do
      let(:test_url) { "http://straße.de" }
      let(:normalized_url) { described_class.parse(url).normalized }

      it "does conform to the IDNA2008 protocol" do
        expect(normalized_url.domain).to eq("xn--strae-oqa.de")
      end
    end

    context "with URL that has an internationalized TLD in Unicode" do
      let(:test_url) { "https://www.foo.ایران.ir/bar" }
      let(:normalized_url) { described_class.parse(url).normalized }

      describe "#scheme" do
        subject { normalized_url.scheme }
        it { is_expected.to eq("https") }
      end

      describe "#trd" do
        subject { normalized_url.trd }
        it { is_expected.to eq("www") }
      end

      describe "#sld" do
        subject { normalized_url.sld }
        it { is_expected.to eq("foo") }
      end

      describe "#tld" do
        subject { normalized_url.tld }
        it { is_expected.to eq("xn--mgba3a4f16a.ir") }
      end

      describe "#ttld" do
        subject { normalized_url.ttld }
        it { is_expected.to eq("ir") }
      end

      describe "#domain" do
        subject { normalized_url.domain }
        it { is_expected.to eq("foo.xn--mgba3a4f16a.ir") }
      end

      describe "#host" do
        subject { normalized_url.host }
        it { is_expected.to eq("www.foo.xn--mgba3a4f16a.ir") }
      end

      describe "#origin" do
        subject { normalized_url.origin }
        it { is_expected.to eq("https://www.foo.xn--mgba3a4f16a.ir") }
      end

      describe "#path" do
        subject { normalized_url.path }
        it { is_expected.to eq("/bar") }
      end
    end

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

  describe "#userinfo" do
    subject { described_class.parse(url).userinfo }

    context "without authorisation part in URL" do
      let(:url) { "https://blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with user and password part in URL" do
      let(:url) { "https://user:password@blog.twingly.com/" }

      it { is_expected.to eq("user:password") }
    end

    context "with empty user and empty password in URL" do
      let(:url) { "https://:@blog.twingly.com/" }

      it { is_expected.to eq(":") }
    end

    context "with user but empty password in URL" do
      let(:url) { "https://user:@blog.twingly.com/" }

      it { is_expected.to eq("user:") }
    end

    context "with empty user but password in URL" do
      let(:url) { "https://:password@blog.twingly.com/" }

      it { is_expected.to eq(":password") }
    end
  end

  describe "#user" do
    subject { described_class.parse(url).user }

    context "without authorisation part in URL" do
      let(:url) { "https://blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with user and password part in URL" do
      let(:url) { "https://user:password@blog.twingly.com/" }

      it { is_expected.to eq("user") }
    end

    context "with empty user and empty password in URL" do
      let(:url) { "https://:@blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with user but empty password in URL" do
      let(:url) { "https://user:@blog.twingly.com/" }

      it { is_expected.to eq("user") }
    end

    context "with empty user but password in URL" do
      let(:url) { "https://:password@blog.twingly.com/" }

      it { is_expected.to eq("") }
    end
  end

  describe "#password" do
    subject { described_class.parse(url).password }

    context "without authorisation part in URL" do
      let(:url) { "https://blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with user and password part in URL" do
      let(:url) { "https://user:password@blog.twingly.com/" }

      it { is_expected.to eq("password") }
    end

    context "with empty user and empty password in URL" do
      let(:url) { "https://:@blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with user but empty password in URL" do
      let(:url) { "https://user:@blog.twingly.com/" }

      it { is_expected.to eq("") }
    end

    context "with empty user but password in URL" do
      let(:url) { "https://:password@blog.twingly.com/" }

      it { is_expected.to eq("password") }
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
