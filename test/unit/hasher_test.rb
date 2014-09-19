require 'test_helper'

class HasherTest < Test::Unit::TestCase
  context ".taskdb_hash" do
    should "return a MD5 hexdigest" do
      assert_equal Twingly::URL::Hasher.taskdb_hash("http://blog.twingly.com/"),
        "B1E2D5AECF6649C2E44D17AEA3E0F4"
    end
  end

  context ".blogstream_hash" do
    should "return a MD5 hexdigest" do
      assert_equal Twingly::URL::Hasher.blogstream_hash("http://blog.twingly.com/"),
        "B1E2D5AECF6649C2E44D17AEA3E0F4"
    end
  end

  context ".documentdb_hash" do
    should "return a SHA256 unsigned long, native endian digest" do
      assert_equal Twingly::URL::Hasher.documentdb_hash("http://blog.twingly.com/"),
        15340752212397415993
    end
  end

  context ".autopingdb_hash" do
    should "return a SHA256 64-bit signed, native endian digest" do
      assert_equal Twingly::URL::Hasher.autopingdb_hash("http://blog.twingly.com/"),
        -3105991861312135623
    end
  end
end
