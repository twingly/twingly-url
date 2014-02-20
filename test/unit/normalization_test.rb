require 'test_helper'

class NormalizerTest < Test::Unit::TestCase
  context "normalize" do
    setup do
      @normalizer = Twingly::URL::Normalizer
    end

    should "detect two urls in a String" do
      urls = "http://blog.twingly.com/ http://twingly.com/"
      response = @normalizer.normalize(urls)

      response.size.must_equal 2
    end

    should "detect two urls in an Array" do
      urls = %w(http://blog.twingly.com/ http://twingly.com/)
      response = @normalizer.normalize(urls)

      response.size.must_equal 2
    end

    should "return an Array" do
      response = @normalizer.normalize(nil)

      response.must_be_instance_of Array
    end
  end
end
