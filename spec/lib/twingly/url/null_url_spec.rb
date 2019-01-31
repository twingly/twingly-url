# frozen_string_literal: true

require "spec_helper"

require "twingly/url"

describe Twingly::URL::NullURL do
  let(:url) { described_class.new }

  describe "#valid?" do
    subject { url.valid? }
    it { is_expected.to be(false) }
  end

  describe "#normalized" do
    subject { url.normalized }
    it { is_expected.to equal(subject) }
  end

  describe "#scheme" do
    subject { url.scheme }
    it { is_expected.to eq("") }
  end

  describe "#trd" do
    subject { url.trd }
    it { is_expected.to eq("") }
  end

  describe "#sld" do
    subject { url.sld }
    it { is_expected.to eq("") }
  end

  describe "#tld" do
    subject { url.tld }
    it { is_expected.to eq("") }
  end

  describe "#ttld" do
    subject { url.ttld }
    it { is_expected.to eq("") }
  end

  describe "#domain" do
    subject { url.domain }
    it { is_expected.to eq("") }
  end

  describe "#host" do
    subject { url.host }
    it { is_expected.to eq("") }
  end

  describe "#origin" do
    subject { url.origin }
    it { is_expected.to eq("") }
  end

  describe "#path" do
    subject { url.path }
    it { is_expected.to eq("") }
  end

  describe "#normalized_path" do
    subject { url.normalized_path }
    it { is_expected.to eq("") }
  end

  describe "#normalized_scheme" do
    subject { url.normalized_scheme }
    it { is_expected.to eq("") }
  end

  describe "#normalized_host" do
    subject { url.normalized_host }
    it { is_expected.to eq("") }
  end

  describe "#userinfo" do
    subject { url.userinfo }
    it { is_expected.to eq("") }
  end

  describe "#user" do
    subject { url.user }
    it { is_expected.to eq("") }
  end

  describe "#password" do
    subject { url.password }
    it { is_expected.to eq("") }
  end

  context "when receiving call for non-existing method on Twingly::URL" do
    it "raises an error" do
      expect { url.method_does_not_exist }.to raise_error(NoMethodError)
    end
  end
end
