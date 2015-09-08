require "spec_helper"

describe Twingly::URL do
  describe ".parse" do
    %w(http://http http:/// http:// http:/ http: htttp a 1 ?).each do |invalid_url|
      it "handles the invalid url '#{invalid_url}'" do
        expect { described_class.parse(invalid_url) }.not_to raise_error
      end
    end

    describe ".valid?" do
      %w(ftp://blog.twingly.com/ blablahttp://blog.twingly.com/).each do |invalid_url|
        it "returns false for non-http and https" do
          expect(described_class.parse(invalid_url).valid?).to be false
        end
      end

      %w(http://blog.twingly.com/ hTTP://blog.twingly.com/ https://blog.twingly.com).each do |valid_url|
        it "returns true for the valid url '#{valid_url}" do
          expect(described_class.parse(valid_url).valid?).to be true
        end
      end

      it "handles nil input" do
        actual = described_class.parse(nil)
        expect(actual.url).to be_nil
        expect(actual.domain).to be_nil
      end
    end
  end

  describe ".validate" do
    it "returns true for a valid url" do
      expect(described_class.validate("http://blog.twingly.com/")).to be true
    end

    %w(http:// feedville.com,2007-06-19:/blends/16171).each do |invalid_url|
      it "returns false for the invalid url '#{invalid_url}'" do
        expect(described_class.validate(invalid_url)).to be_falsey
      end
    end
  end
end
