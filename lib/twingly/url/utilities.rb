module Twingly
  module URL
    module Utilities
      module_function

      PROTOCOL_EXPRESSION = /^https?:/i

      def remove_scheme(url)
        url.sub(PROTOCOL_EXPRESSION, '')
      end
    end
  end
end
