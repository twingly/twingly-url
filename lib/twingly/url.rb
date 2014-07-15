require 'addressable/uri'
require 'public_suffix'

PublicSuffix::List.private_domains = false

module Twingly
  module URL
    module_function

    def extract_url_and_domain(potential_url)
      url    = Addressable::URI.heuristic_parse(potential_url)
      domain = PublicSuffix.parse(url.host)

      [url, domain]
    rescue PublicSuffix::DomainInvalid
      []
    end

    def validate(potential_url)
      extract_url_and_domain(potential_url).size == 2
    rescue
      false
    end
  end
end
