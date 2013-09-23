require 'postrank-uri'
require 'domainatrix'
require 'uri'

# TODO
# * Handle blogspot.se -> blogspot.com

module Twingly
  module URL
    class Normalizer
      def self.normalize(potential_url)
        PostRank::URI.extract(potential_url).map do |url|
          subdomain = Domainatrix.parse(url).subdomain
          uri = URI.parse(url)
          if subdomain.empty?
            uri.host = "www.#{uri.host}"
          end
          uri.to_s
        end
      end
    end
  end
end

