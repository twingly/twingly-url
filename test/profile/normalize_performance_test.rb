require 'test_helper'
require 'test_profile'

class NormalizerPerformanceTest < Test::Unit::TestCase
  context ".normalize_url" do
    measure "normalizing a short URL", 1000 do
      Twingly::URL::Normalizer.normalize('http://www.duh.se/')
    end
  end
end
