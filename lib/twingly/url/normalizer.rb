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
        url_object = Twingly::URL.parse(potential_url)

        return nil unless url_object.valid?

        url_object.url.scheme = extract_normalized_scheme(url_object)
        url_object.url.host   = extract_normalized_host(url_object)
        url_object.url.path   = extract_normalized_path(url_object)

        url_object.url.to_s
      end

      def extract_normalized_scheme(url_object)
        url_object.url.scheme.downcase
      end

      def extract_normalized_host(url_object)
        host   = url_object.url.normalized_host
        domain = url_object.domain

        unless domain.subdomain?
          host = "www.#{host}"
        end

        host = normalize_blogspot(host, domain)
        host = host.downcase

        host
      end

      def extract_normalized_path(url_object)
        path = strip_trailing_slashes(url_object.url.path)

        (path.empty?) ? "/" : path
      end

      def strip_trailing_slashes(path)
        path.sub(ENDS_WITH_SLASH, "")
      end

      def normalize_blogspot(host, domain)
        if domain.sld.downcase == "blogspot"
          host.sub(/\Awww\./i, "").sub(/#{domain.tld}\z/i, "com")
        else
          host
        end
      end
    end
  end
end

