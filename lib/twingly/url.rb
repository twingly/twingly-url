require "addressable/uri"
require "addressable/idna/native"
require "public_suffix"

require_relative "url/null_url"
require_relative "url/error"
require_relative "version"

PublicSuffix::List.private_domains = false

module Twingly
  class URL
    include Comparable

    ACCEPTED_SCHEMES = /\Ahttps?\z/i
    ENDS_WITH_SLASH = /\/+$/
    ERRORS_TO_EXTEND = [
      Addressable::URI::InvalidURIError,
      PublicSuffix::DomainInvalid,
      IDN::Idna::IdnaError,
    ]

    private_constant :ACCEPTED_SCHEMES, :ENDS_WITH_SLASH, :ERRORS_TO_EXTEND

    class << self
      def parse(potential_url)
        internal_parse(potential_url)
      rescue Twingly::URL::Error, Twingly::URL::Error::ParseError => error
        NullURL.new
      end

      def internal_parse(potential_url)
        addressable_uri = to_addressable_uri(potential_url)
        raise Twingly::URL::Error::ParseError if addressable_uri.nil?

        scheme = addressable_uri.scheme
        raise Twingly::URL::Error::ParseError unless scheme =~ ACCEPTED_SCHEMES

        display_uri = addressable_display_uri(addressable_uri)

        public_suffix_domain = PublicSuffix.parse(display_uri.host)
        raise Twingly::URL::Error::ParseError if public_suffix_domain.nil?

        raise Twingly::URL::Error::ParseError if public_suffix_domain.sld.nil?

        new(addressable_uri, public_suffix_domain)
      rescue *ERRORS_TO_EXTEND => error
        error.extend(Twingly::URL::Error)
        raise
      end

      def to_addressable_uri(potential_url)
       if potential_url.is_a?(Addressable::URI)
          potential_url
        else
          potential_url = String(potential_url)
          potential_url = potential_url.scrub
          potential_url = potential_url.strip

          Addressable::URI.heuristic_parse(potential_url)
        end
      end

      # Workaround for the following bug in addressable:
      # https://github.com/sporkmonger/addressable/issues/224
      def addressable_display_uri(addressable_uri)
        addressable_uri.display_uri
      rescue ArgumentError => error
        if error.message.include?("invalid byte sequence in UTF-8")
          raise Twingly::URL::Error::ParseError
        end

        raise
      end

      private :new
      private :internal_parse
      private :to_addressable_uri
      private :addressable_display_uri
    end

    def initialize(addressable_uri, public_suffix_domain)
      @addressable_uri      = addressable_uri
      @public_suffix_domain = public_suffix_domain
    end

    def scheme
      addressable_uri.scheme
    end

    def trd
      public_suffix_domain.trd.to_s
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

      self.class.parse(normalized_url)
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
      true
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
