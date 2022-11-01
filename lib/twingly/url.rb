# frozen_string_literal: true

require "addressable/idna/pure"
require "addressable/uri"
require "public_suffix"

require "twingly/public_suffix_list"
require "twingly/url/null_url"
require "twingly/url/error"
require "twingly/version"

module Twingly
  class URL
    include Comparable

    ACCEPTED_SCHEMES = /\Ahttps?\z/i.freeze
    CUSTOM_PSL = PublicSuffixList.with_punycoded_names
    ENDS_WITH_SLASH = /\/+$/.freeze
    STARTS_WITH_WWW = /\Awww\./i.freeze
    ERRORS_TO_EXTEND = [
      Addressable::IDNA::PunycodeBigOutput,
      Addressable::URI::InvalidURIError,
      PublicSuffix::DomainInvalid,
    ].freeze
    DOT = "."
    HYPHEN = "-"
    CARRIAGE_RETURN = "\u000D"
    LINE_FEED = "\u000A"
    NBSP = "\u00A0"
    SPACE = "\u0020"
    WHITESPACE_CHARS = [
      CARRIAGE_RETURN,
      LINE_FEED,
      NBSP,
      SPACE,
    ].join.freeze
    LEADING_AND_TRAILING_WHITESPACE =
      /\A[#{WHITESPACE_CHARS}]+|[#{WHITESPACE_CHARS}]+\z/.freeze
    LETTERS_DIGITS_HYPHEN = /\A[a-zA-Z0-9-]+\z/.freeze

    private_constant :ACCEPTED_SCHEMES
    private_constant :CUSTOM_PSL
    private_constant :STARTS_WITH_WWW
    private_constant :ENDS_WITH_SLASH
    private_constant :ERRORS_TO_EXTEND
    private_constant :DOT
    private_constant :HYPHEN
    private_constant :NBSP
    private_constant :SPACE
    private_constant :WHITESPACE_CHARS
    private_constant :LEADING_AND_TRAILING_WHITESPACE
    private_constant :LETTERS_DIGITS_HYPHEN

    class << self
      def parse(potential_url)
        internal_parse(potential_url)
      rescue Twingly::URL::Error, Twingly::URL::Error::ParseError => error
        NullURL.new
      rescue Exception => error
        error.extend(Twingly::URL::Error)
        raise
      end

      def internal_parse(input)
        potential_url   = clean_input(input)
        addressable_uri = Addressable::URI.heuristic_parse(potential_url)
        raise Twingly::URL::Error::ParseError if addressable_uri.nil?

        scheme = addressable_uri.scheme
        raise Twingly::URL::Error::ParseError unless scheme =~ ACCEPTED_SCHEMES

        # URLs that can't be normalized should not be valid
        try_addressable_normalize(addressable_uri)

        host = addressable_uri.host
        public_suffix_domain = PublicSuffix.parse(host, list: CUSTOM_PSL,
          default_rule: nil)
        raise Twingly::URL::Error::ParseError if public_suffix_domain.nil?

        raise Twingly::URL::Error::ParseError if public_suffix_domain.sld.nil?

        new(addressable_uri, public_suffix_domain)
      rescue *ERRORS_TO_EXTEND => error
        error.extend(Twingly::URL::Error)
        raise
      end

      def clean_input(input)
        input = String(input)
        input = input.scrub
        input = strip_whitespace(input)
      end

      def strip_whitespace(input)
        return input unless input.encoding == Encoding::UTF_8

        input.gsub(LEADING_AND_TRAILING_WHITESPACE, "")
      end

      def try_addressable_normalize(addressable_uri)
        ascii_host = addressable_uri.normalize.host
        raise Twingly::URL::Error::ParseError unless valid_hostname?(ascii_host)
      rescue ArgumentError => error
        if error.message.include?("invalid byte sequence in UTF-8")
          raise Twingly::URL::Error::ParseError
        end

        raise
      end

      def valid_hostname?(hostname)
        return false if hostname.nil?

        # No need to check the TLD, the public suffix list does that
        labels = hostname.split(DOT)[0...-1].map(&:to_s)

        labels.all? { |label| valid_label?(label) }
      end

      def valid_label?(label)
        return false if label.start_with?(HYPHEN)
        return false if label.end_with?(HYPHEN)

        label.match?(LETTERS_DIGITS_HYPHEN)
      end

      private :new
      private :internal_parse
      private :clean_input
      private :strip_whitespace
      private :try_addressable_normalize
      private :valid_hostname?
      private :valid_label?
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

    # Many ccTLDs have a second level[1] underneath their ccTLD, use this when
    # you don't care about the second level.
    #
    # [1]: https://en.wikipedia.org/wiki/Second-level_domain
    def ttld
      tld.split(".").last
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

    def userinfo
      addressable_uri.userinfo.to_s
    end

    def user
      addressable_uri.user.to_s
    end

    def password
      addressable_uri.password.to_s
    end

    def valid?
      true
    end

    def <=>(other)
      self.to_s <=> other.to_s
    end

    def eql?(other)
      return false unless other.is_a?(self.class)

      self.hash == other.hash
    end

    def hash
      self.to_s.hash
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
        host.sub(STARTS_WITH_WWW, "").sub(/#{domain.tld}\z/i, "com")
      else
        host
      end
    end

    def strip_trailing_slashes(path)
      path.sub(ENDS_WITH_SLASH, "")
    end
  end
end
