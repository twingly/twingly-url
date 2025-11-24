# frozen_string_literal: true

require "spec_helper"

require "twingly/public_suffix_list"

describe Twingly::PublicSuffixList do
  describe ".with_punycoded_names" do
    subject { described_class.with_punycoded_names(encoding: encoding) }

    context "when the list is data is read with the default encoding" do
      subject { described_class.with_punycoded_names }

      it { is_expected.to be_a(PublicSuffix::List) }
    end

    context "when the list data is read as UTF-8" do
      let(:encoding) { Encoding::UTF_8 }

      it { is_expected.to be_a(PublicSuffix::List) }
    end

    context "when the list data is read as US-ASCII" do
      let(:encoding) { Encoding::US_ASCII }
      # https://github.com/ruby/ruby/commit/571d21fd4a2e877f49b4ff918832bda9a5e8f91c
      let(:expected_error) do
        if RUBY_VERSION >= "3.2.0" && RUBY_ENGINE != "jruby"
          Encoding::CompatibilityError
        else
          ArgumentError
        end
      end

      it "parsing the data will fail" do
        expect { subject }.
          to raise_error(expected_error, "invalid byte sequence in US-ASCII")
      end
    end
  end
end
