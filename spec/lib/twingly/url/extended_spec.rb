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
  context "with percent_encode: true" do
    let(:raw_spelling)     { "https://example.com/päge?id=1" }
    let(:encoded_spelling) { "https://example.com/p%C3%A4ge?id=1" }
    it "converges raw and percent-encoded spellings of the same URL" do
      raw     = described_class.normalize_and_calculate_urlhash(raw_spelling, percent_encode: true)
      encoded = described_class.normalize_and_calculate_urlhash(encoded_spelling, percent_encode: true)

      expect(raw.to_h).to eq(encoded.to_h)
      expect(raw.normalized_url).to eq("//www.example.com/p%C3%A4ge?id=1")
    end

    it "does not converge the spellings when the option is off" do
      raw     = described_class.normalize_and_calculate_urlhash(raw_spelling)
      encoded = described_class.normalize_and_calculate_urlhash(encoded_spelling)

      expect(raw.urlhash).not_to eq(encoded.urlhash)
    end

    it "converges lowercase and uppercase hex spellings" do
      lower = described_class.normalize_and_calculate_urlhash("https://example.com/p%c3%a4ge?id=1", percent_encode: true)
      upper = described_class.normalize_and_calculate_urlhash("https://example.com/p%C3%A4ge?id=1", percent_encode: true)

      expect(lower.to_h).to eq(upper.to_h)
    end

    it "strips a blacklisted matrix parameter whose name is percent-encoded" do
      hidden = described_class.normalize_and_calculate_urlhash("https://example.com/path;%6Asessionid=ABC?id=1", percent_encode: true)
      plain  = described_class.normalize_and_calculate_urlhash("https://example.com/path?id=1", percent_encode: true)

      expect(hidden.to_h).to eq(plain.to_h)
    end

    it "is a no-op for an already canonical URL" do
      url = "https://example.com/p%C3%A4ge;jsessionid=X?id=1"

      with_option    = described_class.normalize_and_calculate_urlhash(url, percent_encode: true)
      without_option = described_class.normalize_and_calculate_urlhash(url)

      expect(with_option.to_h).to eq(without_option.to_h)
    end

    it "keeps percent-encoded reserved characters encoded" do
      url = "https://example.com/login?next=https%3A%2F%2Fexample.com%2Faccount"

      result = described_class.normalize_and_calculate_urlhash(url, percent_encode: true)

      expect(result.normalized_url).to eq("//www.example.com/login?next=https%3A%2F%2Fexample.com%2Faccount")
    end

    it "is idempotent over its own url output" do
      first  = described_class.normalize_and_calculate_urlhash("https://example.com/päge;jsessionid=X?utm_source=y&id=1", percent_encode: true)
      second = described_class.normalize_and_calculate_urlhash(first.url, percent_encode: true)

      expect(second.to_h).to eq(first.to_h)
    end

    it "returns the same result for an already parsed Extended instance as for the string" do
      parsed = described_class.parse(raw_spelling)

      from_instance = described_class.normalize_and_calculate_urlhash(parsed, percent_encode: true)
      from_string   = described_class.normalize_and_calculate_urlhash(raw_spelling, percent_encode: true)

      expect(from_instance.to_h).to eq(from_string.to_h)
    end

    context "with an invalid URL" do
      it "still returns a result where all attributes are set to nil" do
        result = described_class.normalize_and_calculate_urlhash("http:// example.com? hello # there", percent_encode: true)

        expect(result).to have_attributes(url:            nil,
                                          normalized_url: nil,
                                          urlhash:        nil,
                                          legacy_urlhash: nil)
      end
    end

    it "leaves every blacklisted parameter name unchanged by canonicalization" do
      names = described_class::BLACKLISTED_QUERY_PARAMETERS + described_class::BLACKLISTED_MATRIX_PARAMETERS

      names.each do |name|
        url = "https://example.com/;#{name}=v?#{name}=v"

        expect(described_class.send(:canonicalize_percent_encoding, url)).to eq(url)
      end
    end

    it "decodes a fully percent-encoded spelling of every blacklisted parameter name back to the name itself" do
      names = described_class::BLACKLISTED_QUERY_PARAMETERS + described_class::BLACKLISTED_MATRIX_PARAMETERS

      names.each do |name|
        encoded_name = name.each_char.map { |char| format("%%%02X", char.ord) }.join

        canonical = described_class.send(:canonicalize_percent_encoding, "https://example.com/;#{encoded_name}=v?#{encoded_name}=v")

        expect(canonical).to eq("https://example.com/;#{name}=v?#{name}=v")
      end
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
