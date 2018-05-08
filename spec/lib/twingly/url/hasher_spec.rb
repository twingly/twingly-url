require "spec_helper"

require "twingly/url/hasher"

describe Twingly::URL::Hasher do
  describe ".taskdb_hash" do
    it "returns a MD5 hexdigest" do
      expect(Twingly::URL::Hasher.taskdb_hash("http://blog.twingly.com/")).to eq "B1E2D5AECF6649C2E44D17AEA3E0F4"
    end
  end

  describe ".blogstream_hash" do
    it "returns a MD5 hexdigest" do
      expect(Twingly::URL::Hasher.blogstream_hash("http://blog.twingly.com/")).to eq "B1E2D5AECF6649C2E44D17AEA3E0F4"
    end
  end

  describe ".documentdb_hash" do
    it "returns a SHA256 unsigned long, native endian digest" do
      expect(Twingly::URL::Hasher.documentdb_hash("http://blog.twingly.com/")).to eq 15340752212397415993
    end
  end

  describe ".autopingdb_hash" do
    let(:expected) { -3105991861312135623 }

    it "returns a SHA256 64-bit signed, native endian digest" do
      expect(Twingly::URL::Hasher.autopingdb_hash("http://blog.twingly.com/")).to eq expected
    end
  end
end
