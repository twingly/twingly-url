require "addressable/uri"
require "public_suffix"

require_relative "url/null_url"
require_relative "url/error"

PublicSuffix::List.private_domains = false

module Twingly
  class URL
    include Comparable

    SCHEMES = %w(http https)
    ENDS_WITH_SLASH = /\/+$/

    def self.parse(potential_url)
      potential_url = String(potential_url)
      potential_url = potential_url.scrub
      potential_url = potential_url.strip

      internal_parse(potential_url)
    rescue Twingly::URL::Error, Twingly::URL::Error::ParseError => error
      NullURL.new
    end

    def self.internal_parse(potential_url)
      addressable_uri = to_addressable_uri(potential_url)
      raise Twingly::Error::ParseError if addressable_uri.nil?

      public_suffix_domain = PublicSuffix.parse(addressable_uri.display_uri.host)
      raise Twingly::Error::ParseError if public_suffix_domain.nil?

      self.new(addressable_uri, public_suffix_domain)
    rescue Addressable::URI::InvalidURIError, PublicSuffix::DomainInvalid => error
      error.extend(Twingly::URL::Error)
      raise
    end

    def self.to_addressable_uri(potential_url)
     if potential_url.is_a?(Addressable::URI)
        potential_url
      else
        Addressable::URI.heuristic_parse(potential_url)
      end
    end

    def initialize(addressable_uri, public_suffix_domain)
      unless addressable_uri.is_a?(Addressable::URI)
        raise ArgumentError, "First parameter must be an Addressable::URI"
      end

      unless public_suffix_domain.is_a?(PublicSuffix::Domain)
        raise ArgumentError, "Second parameter must be a PublicSuffix::Domain"
      end

      @addressable_uri      = addressable_uri
      @public_suffix_domain = public_suffix_domain
    end

    def scheme
      addressable_uri.scheme
    end

    def trd
      public_suffix_domain.trd
    end

    def sld
      public_suffix_domain.sld
    end

    def tld
      public_suffix_domain.tld
    end

    def domain
      public_suffix_domain.domain
    end

    def host
      addressable_uri.host
    end

    def origin
      addressable_uri.origin
    end

    def path
      addressable_uri.path
    end

    def without_scheme
      self.to_s.sub(/\A#{scheme}:/, "")
    end

    def normalized
      normalized_url = addressable_uri.dup

      normalized_url.scheme = normalized_scheme
      normalized_url.host   = normalized_host
      normalized_url.path   = normalized_path

      self.class.internal_parse(normalized_url)
    end

    def normalized_scheme
      scheme.downcase
    end

    def normalized_host
      host   = addressable_uri.normalized_host
      domain = public_suffix_domain

      unless domain.subdomain?
        host = "www.#{host}"
      end

      host = normalize_blogspot(host, domain)

      host
    end

    def normalized_path
      path = strip_trailing_slashes(addressable_uri.path)

      (path.empty?) ? "/" : path
    end

    def valid?
      SCHEMES.include?(normalized_scheme)
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    def to_s
      addressable_uri.to_s
    end

    def inspect
      sprintf("#<%s:0x%x %s>", self.class.name, __id__, self.to_s)
    end

    private

    attr_reader :addressable_uri, :public_suffix_domain

    def normalize_blogspot(host, domain)
      if domain.sld.downcase == "blogspot"
        host.sub(/\Awww\./i, "").sub(/#{domain.tld}\z/i, "com")
      else
        host
      end
    end

    def strip_trailing_slashes(path)
      path.sub(ENDS_WITH_SLASH, "")
    end
  end
end
