# frozen_string_literal: true

require "twingly/url/extended"

RSpec.describe Twingly::URL::Extended do
  describe "#normalized" do
    subject { described_class.parse(url).normalized.to_s }

    context "removes both matrix and query parameters" do
      let(:url)      { "https://example.com/path;jsessionid=ABC.123?id=1&utm_source=google&name=test" }
      let(:expected) { "https://www.example.com/path?id=1&name=test" }

      it { is_expected.to eq(expected) }
    end

    context "applies parent path normalization after removing matrix parameters" do
      let(:url)      { "https://example.com/article/;jsessionid=XYZ" }
      let(:expected) { "https://www.example.com/article" }

      it { is_expected.to eq(expected) }
    end

    context "removes the fragment" do
      let(:url)      { "https://example.com/#foo" }
      let(:expected) { "https://www.example.com/" }

      it { is_expected.to eq(expected) }
    end

    context "removes the UTM parameters" do
      let(:url)      { "https://example.com/?baz=qux&#{utm_query_parameters}&foo=bar" }
      let(:expected) { "https://www.example.com/?baz=qux&foo=bar" }

      let(:utm_query_parameters) do
        [
          "utm_source=foo",
          "utm_medium=bar",
          "utm_campaign=baz",
          "utm_term=qux",
          "utm_content=quux",
        ].join("&")
      end

      it { is_expected.to eq(expected) }
    end

    context "removes both the UTM parameters and the ending '?' when the URL only contains UTM query parameters" do
      let(:url)      { "https://example.com/?utm_source=foo&utm_medium=bar" }
      let(:expected) { "https://www.example.com/" }

      it { is_expected.to eq(expected) }
    end

    context "removes both the UTM parameters and the fragment" do
      let(:url)      { "https://example.com/?baz=qux&utm_source=123&foo=bar#quux#something" }
      let(:expected) { "https://www.example.com/?baz=qux&foo=bar" }

      it { is_expected.to eq(expected) }
    end

    context "sorts the query parameters" do
      let(:url)      { "https://example.com/?foo=bar&baz=qux&asd=123" }
      let(:expected) { "https://www.example.com/?asd=123&baz=qux&foo=bar" }

      it { is_expected.to eq(expected) }
    end

    context "returns a normalized URL without query parameters" do
      let(:url)      { "https://example.com/blog" }
      let(:expected) { "https://www.example.com/blog" }

      it { is_expected.to eq(expected) }
    end

    context "keeps the embedded URL percent-encoded in the query" do
      let(:url)      { "https://example.com/login?next=https://example.com/account" }
      let(:expected) { "https://www.example.com/login?next=https%3A%2F%2Fexample.com%2Faccount" }

      it { is_expected.to eq(expected) }
    end

    context "with addressable_normalize: true" do
      subject { described_class.parse(url).normalized(addressable_normalize: true).to_s }

      context "removes dot segments before the trailing slash is stripped" do
        let(:url)      { "https://example.com/a/../news/." }
        let(:expected) { "https://www.example.com/news" }

        it { is_expected.to eq(expected) }
      end

      context "decodes a percent-encoded blacklisted matrix parameter name before stripping it" do
        let(:url)      { "https://example.com/path;%6Asessionid=ABC?id=1" }
        let(:expected) { "https://www.example.com/path?id=1" }

        it { is_expected.to eq(expected) }
      end

      context "still removes blacklisted parameters and the fragment and sorts the query" do
        let(:url)      { "https://example.com/p%c3%a4ge;jsessionid=X?utm_source=y&b=2&a=1#frag" }
        let(:expected) { "https://www.example.com/p%C3%A4ge?a=1&b=2" }

        it { is_expected.to eq(expected) }
      end

      context "keeps the embedded URL percent-encoded in the query" do
        let(:url)      { "https://example.com/login?next=https://example.com/account" }
        let(:expected) { "https://www.example.com/login?next=https%3A%2F%2Fexample.com%2Faccount" }

        it { is_expected.to eq(expected) }
      end
    end
  end

  describe "#addressable_normalized" do
    subject { described_class.parse(url).addressable_normalized }

    let(:url) { "https://example.com/a/../p%c3%a4ge;%6Asessionid=X?utm_source=y#frag" }

    it { is_expected.to be_a(described_class) }

    context "returns the URL canonicalized by Addressable" do
      let(:expected) { "https://example.com/p%C3%A4ge;jsessionid=X?utm_source=y#frag" }

      it { expect(subject.to_s).to eq(expected) }
    end

    it "does not modify the original instance" do
      original = described_class.parse(url)
      before   = original.to_s

      original.addressable_normalized

      expect(original.to_s).to eq(before)
    end
  end

  describe "#original_url_without_blacklisted_parameters" do
    subject { described_class.parse(url).original_url_without_blacklisted_parameters }

    context "removes the UTM parameters" do
      let(:url)      { "https://example.com/?baz=qux&#{utm_query_parameters}&foo=bar" }
      let(:expected) { "https://example.com/?baz=qux&foo=bar" }

      let(:utm_query_parameters) do
        [
          "utm_source=foo",
          "utm_medium=bar",
          "utm_campaign=baz",
          "utm_term=qux",
          "utm_content=quux",
        ].join("&")
      end

      it { is_expected.to eq(expected) }
    end

    context "removes both the UTM parameters and the ending '?' when the URL only contains UTM query parameters" do
      let(:url)      { "https://example.com/?utm_source=foo&utm_medium=bar" }
      let(:expected) { "https://example.com/" }

      it { is_expected.to eq(expected) }
    end
  end

  describe ".normalize_and_calculate_urlhash" do
    let(:url)              { "https://example.com" }
    let(:raw_spelling)     { "https://example.com/päge?id=1" }
    let(:encoded_spelling) { "https://example.com/p%C3%A4ge?id=1" }

    it "produces same hash when blacklisted query parameters differ" do
      url_with = "https://example.com/page?id=1&session=x&PHPSESSID=y&utm_source=z&cb=w"
      url_without = "https://example.com/page?id=1"

      result_with = described_class.normalize_and_calculate_urlhash(url_with)
      result_without = described_class.normalize_and_calculate_urlhash(url_without)

      expect(result_with.urlhash).to eq(result_without.urlhash)
      expect(result_with.legacy_urlhash).to eq(result_without.legacy_urlhash)
    end

    it "produces same hash when blacklisted matrix parameters differ" do
      url_with = "https://example.com/path;jsessionid=ABC.123;allowed_matrix_param=yes;JSESSIONID_B2BCH=XYZ"
      url_without = "https://example.com/path;allowed_matrix_param=yes"

      result_with = described_class.normalize_and_calculate_urlhash(url_with)
      result_without = described_class.normalize_and_calculate_urlhash(url_without)

      expect(result_with.urlhash).to eq(result_without.urlhash)
      expect(result_with.legacy_urlhash).to eq(result_without.legacy_urlhash)
    end

    it "returns original url, addressable normalized url, normalized url, urlhash and legacy_urlhash" do
      expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url:                        url,
                                                                 addressable_normalized_url: "https://example.com/",
                                                                 normalized_url:             "//www.example.com/",
                                                                 urlhash:                    "1119909257551956256",
                                                                 legacy_urlhash:             "14653629529287702089")
    end

    it "calculates the legacy urlhash from the normalized URL with its scheme kept" do
      result = described_class.normalize_and_calculate_urlhash("https://example.com/blog")

      expect(result.legacy_urlhash)
        .to eq(Twingly::URL::Hasher.documentdb_hash("https:#{result.normalized_url}").to_s)
    end

    it "returns the addressable normalized URL without applying it to the normalized URL" do
      result = described_class.normalize_and_calculate_urlhash("https://example.com/news/.")

      expect(result).to have_attributes(addressable_normalized_url: "https://example.com/news/",
                                        normalized_url:             "//www.example.com/news/.")
    end

    it "produces different hashes for raw and percent-encoded spellings of the same URL" do
      raw     = described_class.normalize_and_calculate_urlhash(raw_spelling)
      encoded = described_class.normalize_and_calculate_urlhash(encoded_spelling)

      expect(raw.urlhash).not_to eq(encoded.urlhash)
    end

    ["", nil].each do |empty_value|
      context "when url is #{empty_value.inspect}" do
        let(:url) { empty_value }

        it "returns a result where all attributes are set to nil" do
          expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url:                        nil,
                                                                     addressable_normalized_url: nil,
                                                                     normalized_url:             nil,
                                                                     urlhash:                    nil,
                                                                     legacy_urlhash:             nil)
        end
      end
    end

    context "with an invalid URL" do
      let(:url) { "http:// example.com? hello # there" }

      it "returns a result where all attributes are set to nil" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url:                        nil,
                                                                   addressable_normalized_url: nil,
                                                                   normalized_url:             nil,
                                                                   urlhash:                    nil,
                                                                   legacy_urlhash:             nil)
      end
    end

    context "with addressable_normalize: true" do
      it "produces same hash for raw and percent-encoded spellings of the same URL" do
        raw     = described_class.normalize_and_calculate_urlhash(raw_spelling, addressable_normalize: true)
        encoded = described_class.normalize_and_calculate_urlhash(encoded_spelling, addressable_normalize: true)

        expect(raw.urlhash).to eq(encoded.urlhash)
        expect(raw.legacy_urlhash).to eq(encoded.legacy_urlhash)
      end

      it "applies the Addressable normalization before the extended normalization" do
        result = described_class.normalize_and_calculate_urlhash("https://example.com/news/.", addressable_normalize: true)

        expect(result.normalized_url).to eq("//www.example.com/news")
      end

      it "returns the same original url as without the option" do
        with_option    = described_class.normalize_and_calculate_urlhash(raw_spelling, addressable_normalize: true)
        without_option = described_class.normalize_and_calculate_urlhash(raw_spelling)

        expect(with_option.url).to eq(without_option.url)
      end

      it "keeps blacklisted parameters in the addressable normalized URL" do
        url = "https://example.com/a;jsessionid=ABC/b?utm_source=x"

        result = described_class.normalize_and_calculate_urlhash(url, addressable_normalize: true)

        expect(result).to have_attributes(url:                        "https://example.com/a/b",
                                          addressable_normalized_url: url,
                                          normalized_url:             "//www.example.com/a/b")
      end

      it "is a no-op for an already canonical URL" do
        url = "https://example.com/p%C3%A4ge;jsessionid=X?id=1"

        with_option    = described_class.normalize_and_calculate_urlhash(url, addressable_normalize: true)
        without_option = described_class.normalize_and_calculate_urlhash(url)

        expect(with_option.to_h).to eq(without_option.to_h)
      end

      context "with an invalid URL" do
        it "still returns a result where all attributes are set to nil" do
          result = described_class.normalize_and_calculate_urlhash("http:// example.com? hello # there", addressable_normalize: true)

          expect(result).to have_attributes(url:                        nil,
                                            addressable_normalized_url: nil,
                                            normalized_url:             nil,
                                            urlhash:                    nil,
                                            legacy_urlhash:             nil)
        end
      end
    end
  end
end
