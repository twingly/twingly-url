require 'addressable/uri'
require 'public_suffix'

PublicSuffix::List.private_domains = false

SCHEMES = %w(http https)

module Twingly
  module URL
    module_function

    UrlObject = Struct.new(:url, :domain) do
      def valid?
        url && domain && SCHEMES.include?(url.normalized_scheme)
      end
    end

    def parse(potential_url)
      url, domain = extract_url_and_domain(potential_url)
      UrlObject.new(url, domain)
    end

    def extract_url_and_domain(potential_url)
      url    = Addressable::URI.heuristic_parse(potential_url)
      domain = PublicSuffix.parse(url.host) if url

      [url, domain]
    rescue PublicSuffix::DomainInvalid, Addressable::URI::InvalidURIError
      []
    end

    def validate(potential_url)
      parse(potential_url).valid?
    end
  end
end
