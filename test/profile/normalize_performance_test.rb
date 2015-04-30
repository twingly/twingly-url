require 'test_helper'
require 'test_profile'

class NormalizerPerformanceTest < Minitest::Test
  context ".normalize_url" do
    measure "normalizing a short URL", 1000 do
      Twingly::URL::Normalizer.normalize_url('http://www.duh.se/')
    end
  end
end
