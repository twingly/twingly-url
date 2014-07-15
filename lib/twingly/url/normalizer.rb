require 'twingly/url'

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
        url, domain = Twingly::URL.extract_url_and_domain(potential_url)

        return nil unless url || domain

        unless domain.subdomain?
          url.host = "www.#{domain}"
        end

        if url.path.empty?
          url.path = "/"
        end

        url.to_s
      end
    end
  end
end

