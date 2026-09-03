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
    let(:url) { "https://example.com" }

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

    it "returns both original url, normalized url, urlhash and legacy_urlhash" do
      expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url: url,
                                                                 normalized_url: "//www.example.com/",
                                                                 urlhash:        "1119909257551956256",
                                                                 legacy_urlhash: "14653629529287702089")
    end

    it "calculates the legacy urlhash from the normalized URL with its scheme kept" do
      result = described_class.normalize_and_calculate_urlhash("https://example.com/blog")

      expect(result.legacy_urlhash)
        .to eq(Twingly::URL::Hasher.documentdb_hash("https:#{result.normalized_url}").to_s)
    end

    ["", nil].each do |empty_value|
      context "when url is #{empty_value.inspect}" do
        let(:url) { empty_value }

        it "returns a result where all attributes are set to nil" do
          expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url:            nil,
                                                                     normalized_url: nil,
                                                                     urlhash:        nil,
                                                                     legacy_urlhash: nil)
        end
      end
    end

    context "with an invalid URL" do
      let(:url) { "http:// example.com? hello # there" }

      it "returns a result where all attributes are set to nil" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url:            nil,
                                                                   normalized_url: nil,
                                                                   urlhash:        nil,
                                                                   legacy_urlhash: nil)
      end
    end
  end

end
