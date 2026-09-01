# frozen_string_literal: true

require "twingly/url/extended"

RSpec.describe Twingly::URL::Extended do
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

    it "removes both matrix and query parameters" do
      url = "https://example.com/path;jsessionid=ABC.123?id=1&utm_source=google&name=test"
      result = described_class.normalize_and_calculate_urlhash(url)

      expect(result.normalized_url).to eq("//www.example.com/path?id=1&name=test")
    end

    it "applies parent path normalization after removing matrix parameters" do
      url_with_trailing_slash = "https://example.com/article/;jsessionid=XYZ"
      url_without_trailing_slash = "https://example.com/article;jsessionid=XYZ"

      urlhash_with = described_class.normalize_and_calculate_urlhash(url_with_trailing_slash)
      urlhash_without = described_class.normalize_and_calculate_urlhash(url_without_trailing_slash)

      expect(urlhash_with.normalized_url).to eq("//www.example.com/article")
      expect(urlhash_without.normalized_url).to eq("//www.example.com/article")
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

    context "when the URL contains query parameters" do
      let(:url) { "https://example.com/?baz=qux&foo=bar" }

      it "keeps the query values in the normalized URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/?baz=qux&foo=bar")
      end
    end

    context "when the URL contains UTM query parameters" do
      let(:url) { "https://example.com/?baz=qux&#{utm_query_parameters}&foo=bar" }

      let(:utm_query_parameters) do
        [
          "utm_source=foo",
          "utm_medium=bar",
          "utm_campaign=baz",
          "utm_term=qux",
          "utm_content=quux",
        ].join("&")
      end

      it "removes the UTM parameters from the original URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url: "https://example.com/?baz=qux&foo=bar")
      end

      it "removes the UTM parameters from the normalized URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/?baz=qux&foo=bar")
      end
    end

    context "when the URL only contains UTM query parameters" do
      let(:url) { "https://example.com/?utm_source=foo&utm_medium=bar" }

      it "removes both the UTM parameters and the ending '?' from the original URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(url: "https://example.com/")
      end

      it "removes both the UTM parameters and the ending '?' from the normalized URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/")
      end
    end

    context "when the URL contains a fragment" do
      let(:url) { "https://example.com/#foo" }

      it "removes the fragment from the normalized URL" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/")
      end
    end

    context "when the URL contains both UTM parameters and a fragment" do
      let(:url) { "https://example.com/?baz=qux&utm_source=123&foo=bar#quux#something" }

      it "removes both the UTM parameters and the fragment" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/?baz=qux&foo=bar")
      end
    end

    context "when the URL query parameters aren't sorted" do
      let(:url) { "https://example.com/?foo=bar&baz=qux&asd=123" }

      it "sorts the query parameters" do
        expect(described_class.normalize_and_calculate_urlhash(url))
          .to have_attributes(normalized_url: "//www.example.com/?asd=123&baz=qux&foo=bar")
      end
    end

    context "when the URL doesn't contain any parameters" do
      let(:url) { "https://example.com/blog" }

      it "returns a normalized URL without query parameters" do
        expect(described_class.normalize_and_calculate_urlhash(url)).to have_attributes(normalized_url: "//www.example.com/blog")
      end
    end

    context "when a query parameter contains a URL" do
      let(:url) { "https://example.com/login?next=https://example.com/account" }

      it "only strips the leading scheme, keeping the embedded URL percent-encoded in the query" do
        expect(described_class.normalize_and_calculate_urlhash(url))
          .to have_attributes(normalized_url: "//www.example.com/login?next=https%3A%2F%2Fexample.com%2Faccount")
      end
    end

    it "is idempotent over its own url output" do
      first  = described_class.normalize_and_calculate_urlhash("https://example.com/a;jsessionid=X?utm_source=y&id=1")
      second = described_class.normalize_and_calculate_urlhash(first.url)

      expect(second.to_h).to eq(first.to_h)
    end

    context "when given an already parsed Extended instance" do
      let(:url) { "https://example.com/a;jsessionid=X?utm_source=y&id=1" }

      it "returns the same result as for the string, stable across repeated calls" do
        parsed = described_class.parse(url)

        from_instance = described_class.normalize_and_calculate_urlhash(parsed)
        repeated      = described_class.normalize_and_calculate_urlhash(parsed)
        from_string   = described_class.normalize_and_calculate_urlhash(url)

        expect(from_instance.to_h).to eq(from_string.to_h)
        expect(repeated.to_h).to eq(from_instance.to_h)
      end
    end
  end

  describe ".parse" do
    it "returns Extended instances, also from #normalized" do
      url = described_class.parse("https://example.com/a")

      expect(url).to be_a(described_class)
      expect(url.normalized).to be_a(described_class)
    end
  end

  describe "base Twingly::URL isolation" do
    it "does not add the hashing API to the base class" do
      expect(Twingly::URL).not_to respond_to(:normalize_and_calculate_urlhash)
    end

    it "does not change base normalization (blacklisted parameters survive)" do
      normalized = Twingly::URL.parse("https://example.com/?utm_source=x&id=1").normalized

      expect(normalized.to_s).to include("utm_source=x")
    end
  end
end
