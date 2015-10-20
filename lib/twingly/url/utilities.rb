module Twingly
  class URL
    module Utilities
      module_function

      def extract_valid_urls(text_or_array)
        potential_urls = Array(text_or_array).flat_map(&:split)
        potential_urls.map do |potential_url|
          url = Twingly::URL.parse(potential_url)
          url if url.valid?
        end.compact
      end
    end
  end
end
