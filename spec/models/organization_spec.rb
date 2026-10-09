# frozen_string_literal: true

require "rails_helper"

RSpec.describe Organization, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:opportunities).dependent(:destroy) }
  it { is_expected.to define_enum_for(:kind).with_values(company: 0, freelance_client: 1) }

  describe "defaults" do
    it "defaults to kind: company" do
      expect(described_class.new.kind).to eq("company")
    end
  end

  describe ".alphabetical" do
    it "orders organizations by name" do
      z = create(:organization, name: "Zebra Corp")
      a = create(:organization, name: "Acme Corp")

      expect(described_class.alphabetical).to eq([a, z])
    end
  end
end
