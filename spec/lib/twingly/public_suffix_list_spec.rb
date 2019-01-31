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

      it "parsing the data will fail" do
        expect { subject }.
          to raise_error(ArgumentError, "invalid byte sequence in US-ASCII")
      end
    end
  end
end
