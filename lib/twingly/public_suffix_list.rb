require "addressable/idna"
require "public_suffix"

module Twingly
  class PublicSuffixList
    ACE_PREFIX = /\Axn\-\-/i.freeze

    private_constant :ACE_PREFIX

    # Extend the PSL with ASCII form of all internationalized domain names
    def self.with_punycoded_names(encoding: Encoding::UTF_8)
      list_path = PublicSuffix::List::DEFAULT_LIST_PATH
      list_data = File.read(list_path, encoding: encoding)
      list = PublicSuffix::List.parse(list_data, private_domains: false)

      punycoded_names(list).each do |punycoded_name|
        new_rule = PublicSuffix::Rule.factory(punycoded_name)
        list.add(new_rule)
      end

      list
    end

    private_class_method \
    def self.punycoded_names(list)
      names = list.each.map { |rule| Addressable::IDNA.to_ascii(rule.value) }
      names.select { |name| punycoded_name?(name) }
    end

    private_class_method \
    def self.punycoded_name?(name)
      PublicSuffix::Domain.name_to_labels(name).any? do |label|
        label =~ ACE_PREFIX
      end
    end
  end
end
