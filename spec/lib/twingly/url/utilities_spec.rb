require "spec_helper"

require "twingly/url/utilities"

describe Twingly::URL::Utilities do
  describe ".extract_valid_urls" do
    context "when given a string with URLs" do
      it "returns an array of extracted URLs" do
        input    = "hej hopp http://www.twingly.com banan https://www.wordpress.com/forums/sv äpplen/päron"
        actual   = described_class.extract_valid_urls(input).map(&:to_s)
        expected = %w(http://www.twingly.com https://www.wordpress.com/forums/sv)

        expect(actual).to eq(expected)
      end
    end

    context "when given an array with URLs" do
      it "returns an array of extracted URLs" do
        input    = %w(hej hopp http://www.twingly.com banan https://www.wordpress.com/forums/sv äpplen/päron)
        actual   = described_class.extract_valid_urls(input).map(&:to_s)
        expected = %w(http://www.twingly.com https://www.wordpress.com/forums/sv)

        expect(actual).to eq(expected)
      end
    end

    it "always returns an Array" do
      response = described_class.extract_valid_urls(nil)

      expect(response).to eq([])
    end
  end
end
