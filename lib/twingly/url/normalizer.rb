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
        result = Twingly::URL.parse(potential_url)

        return nil unless result.valid?

        unless result.domain.subdomain?
          result.url.host = "www.#{result.domain}"
        end

        if result.url.path.empty?
          result.url.path = "/"
        end

        result.url.to_s
      end
    end
  end
end

