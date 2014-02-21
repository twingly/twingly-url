require 'addressable/uri'
require 'public_suffix'

module Twingly
  module URL
    class Normalizer
      def self.normalize(potential_urls)
        extract_urls(potential_urls).map do |potential_url|
          normalize_url(potential_url)
        end.compact
      end

      def self.extract_urls(potential_urls)
        Array(potential_urls).map(&:split).flatten
      end

      def self.normalize_url(potential_url)
        uri    = Addressable::URI.heuristic_parse(potential_url)
        domain = PublicSuffix.parse(uri.host)

        unless domain.subdomain?
          uri.host = "www.#{domain}"
        end

        if uri.path.empty?
          uri.path = "/"
        end

        uri.to_s
      rescue PublicSuffix::DomainInvalid
      end
    end
  end
end

