module Twingly
  class URL
    class NullURL
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

      def to_s
        ""
      end
    end
  end
end
