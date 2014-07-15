require 'addressable/uri'
require 'public_suffix'

PublicSuffix::List.private_domains = false

module Twingly
  module URL
    module Normalizer
      module_function

      def normalize(potential_urls)
        extract_urls(potential_urls).map do |potential_url|
          normalize_url(potential_url)
        end.compact
      end

      def extract_urls(potential_urls)
        Array(potential_urls).map(&:split).flatten
      end

      def normalize_url(potential_url)
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

