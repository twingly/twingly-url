# frozen_string_literal: true

module Twingly
  class URL
    class NullURL
      include Comparable

      def method_missing(name, *)
        error = NoMethodError.new("undefined method `#{name}'")
        raise error unless Twingly::URL.instance_methods.include?(name)

        ""
      end

      def normalized
        self
      end

      def valid?
        false
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
        ""
      end
    end
  end
end
