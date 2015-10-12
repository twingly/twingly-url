require 'addressable/uri'
require 'public_suffix'

PublicSuffix::List.private_domains = false

module Twingly
  module URL
    module_function

    UrlObject = Struct.new(:url, :domain) do
      SCHEMES = %w(http https)

      def valid?
        url && domain && SCHEMES.include?(url.normalized_scheme)
      end
    end

    def parse(potential_url)
      url, domain = extract_url_and_domain(potential_url)
      UrlObject.new(url, domain)
    end

    def extract_urls(text_or_array)
      potential_urls = Array(text_or_array).flat_map(&:split)
      potential_urls.map do |potential_url|
        potential_url if validate(potential_url)
      end.compact
    end

    def extract_url_and_domain(potential_url)
      addressable_uri = Addressable::URI.heuristic_parse(potential_url)

      return invalid_url unless addressable_uri

      domain = PublicSuffix.parse(addressable_uri.display_uri.host)

      [addressable_uri, domain]
    rescue PublicSuffix::DomainInvalid, Addressable::URI::InvalidURIError
      invalid_url
    end

    def validate(potential_url)
      parse(potential_url).valid?
    end

    def invalid_url
      [nil, nil]
    end
  end
end
