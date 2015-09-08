require 'twingly/url'

module Twingly
  module URL
    module Normalizer
      module_function

      ENDS_WITH_SLASH = /\/+$/

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

        result.url.path = strip_trailing_slashes(result.url.path)

        if result.url.path.empty?
          result.url.path = "/"
        end

        result.url.to_s.downcase
      end

      def strip_trailing_slashes(path)
        path.sub(ENDS_WITH_SLASH, "")
      end
    end
  end
end

