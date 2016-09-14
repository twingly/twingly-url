require "public_suffix"

module Twingly
  class PublicSuffixList
    ACE_PREFIX = /\Axn\-\-/i.freeze

    private_constant :ACE_PREFIX

    # Extend the PSL with ASCII form of all internationalized domain names
    def self.with_punycoded_names
      list_data = File.read(PublicSuffix::List::DEFAULT_LIST_PATH)
      list = PublicSuffix::List.parse(list_data, private_domains: false)

      punycoded_names(list).each do |punycoded_name|
        new_rule = PublicSuffix::Rule.factory(punycoded_name)
        list.add(new_rule, reindex: false)
      end

      list.reindex!

      list
    end

    private_class_method def self.punycoded_names(list)
      names = list.map { |rule| Addressable::IDNA.to_ascii(rule.value) }
      names.select { |name| punycoded_name?(name) }
    end

    private_class_method def self.punycoded_name?(name)
      PublicSuffix::Domain.name_to_labels(name).any? do |label|
        label =~ ACE_PREFIX
      end
    end
  end
end
