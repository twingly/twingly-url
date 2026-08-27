# frozen_string_literal: true

require "twingly/url"
require "twingly/url/hasher"

module Twingly
  class URL
    # The purpose of the twingly-url gems is to replicate the normalization happening in our legacy .NET code.
    # As both twingly-url and the legacy .NET system are used in production, we can't change these things in the
    # gem just yet, which is why this extension was created here.
    class Extended < Twingly::URL
      # Use the same expression as we use in Zambezi: https://github.com/twingly/zambezi/blob/d997871aea199256ddc56762c975b6e961d5a2d1/lib/post_document.rb#L12
      # This way the urlhashes here will be the same as the one we have in Elasticsearch
      PROTOCOL_EXPRESSION = /\Ahttps?:/i

      HashResult = Struct.new(:url, :normalized_url, :urlhash, :legacy_urlhash)

      # These parameters are just used for tracking, and should therefore not be included in the normalized URL
      # See https://en.wikipedia.org/wiki/UTM_parameters
      BLACKLISTED_QUERY_PARAMETERS = %w[
        utm_source
        utm_medium
        utm_campaign
        utm_term
        utm_content
        b_source
        b_medium
        b_campaign
        session
        PHPSESSID
        cb
      ].freeze

      BLACKLISTED_MATRIX_PARAMETERS = %w[
        jsessionid
        jsessionid_jboss
        JSESSIONID_B2BCH
        JSESSIONID_kookbnagWEB
      ].freeze

      # Precompiled regex matching any blacklisted matrix parameter
      # Matches: ;paramname=value where value ends at ; / ? or #
      MATRIX_PARAM_REGEX = %r{;(?:#{BLACKLISTED_MATRIX_PARAMETERS.map { |p| Regexp.escape(p) }.join('|')})=[^;/?#]*}i

      # Taken from twingly-url, with the addition of normalizing the query and fragment components
      # See https://github.com/twingly/twingly-url/blob/e20f5fce077d93e89ef8520961be453c90cfec8c/lib/twingly/url.rb#L185-L193
      def normalized # rubocop:disable Metrics/AbcSize
        normalized_url = addressable_uri.dup

        normalized_url.scheme       = normalized_scheme
        normalized_url.host         = normalized_host
        normalized_url.path         = normalized_path
        normalized_url.query_values = normalized_query
        normalized_url.fragment     = normalized_fragment

        # This is a bit ugly, remove when Twingly::URL is updated to
        # to handle this.
        public_suffix_domain = get_public_suffix_domain(normalized_url.host)
        self.class.send(:new, normalized_url, public_suffix_domain)
      end

      def original_url_without_blacklisted_parameters
        url = addressable_uri.dup
        url.path = without_blacklisted_matrix_parameters(addressable_uri.path)
        url.query_values = without_blacklisted_query_parameters(addressable_uri.query_values)
        url.to_s
      end

      def query_values
        addressable_uri.query_values
      end

      def query
        addressable_uri.query
      end

      private

      # copied the way public_suffix_domain is calculated
      # from Twingly::URL to be able calculate it without calling the parse method.
      def get_public_suffix_domain(host)
        public_suffix_domain = PublicSuffix.parse(host, list: CUSTOM_PSL, default_rule: nil)
        raise Twingly::URL::Error::ParseError if public_suffix_domain.nil?
        raise Twingly::URL::Error::ParseError if public_suffix_domain.sld.nil?

        public_suffix_domain
      end

      def normalized_path
        addressable_uri.path = without_blacklisted_matrix_parameters(addressable_uri.path)

        super
      end

      def normalized_query
        without_blacklisted_query_parameters(addressable_uri.query_values)
      end

      def without_blacklisted_query_parameters(query_values)
        return if query_values.nil?

        values_without_blacklisted_params = query_values.except(*BLACKLISTED_QUERY_PARAMETERS)

        return if values_without_blacklisted_params.empty?

        values_without_blacklisted_params
      end

      def without_blacklisted_matrix_parameters(path)
        # No need to run gsub if there are no matrix parameters
        return path unless path.include?(";")

        path.gsub(MATRIX_PARAM_REGEX, "")
      end

      def normalized_fragment
        nil
      end

      def self.normalize_and_calculate_urlhash(url, percent_encode: false)
        return empty_result if url.to_s.strip.empty?

        url = canonicalize_percent_encoding(url.to_s) if percent_encode

        twingly_url = if url.is_a?(Extended)
                        url
                      else
                        Extended.parse(url)
                      end

        return empty_result unless twingly_url.valid?

        original_url                  = twingly_url.original_url_without_blacklisted_parameters
        normalized_url                = twingly_url.normalized.to_s
        normalized_url_without_scheme = remove_scheme(normalized_url)
        urlhash                       = calculate_urlhash(normalized_url_without_scheme)
        legacy_urlhash                = calculate_urlhash(normalized_url)

        HashResult.new(original_url, normalized_url_without_scheme, urlhash, legacy_urlhash)
      end

      def self.empty_result
        HashResult.new(nil, nil, nil, nil)
      end

      def self.remove_scheme(url)
        url.to_s.sub(PROTOCOL_EXPRESSION, "")
      end

      def self.calculate_urlhash(url)
        Twingly::URL::Hasher.documentdb_hash(url).to_s
      end

      def self.canonicalize_percent_encoding(url)
        Addressable::URI.parse(url).normalize.to_s
      rescue StandardError
        url
      end

      private_class_method :empty_result
      private_class_method :calculate_urlhash
      private_class_method :canonicalize_percent_encoding
    end
  end
end
