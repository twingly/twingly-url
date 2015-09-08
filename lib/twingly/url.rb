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

    def extract_url_and_domain(potential_url)
      url = Addressable::URI.heuristic_parse(potential_url)

      return invalid_url unless url

      url.host = url.normalized_host
      domain = PublicSuffix.parse(url.host)

      [url, domain]
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
