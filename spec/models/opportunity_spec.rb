# frozen_string_literal: true

require "rails_helper"

RSpec.describe Opportunity, type: :model do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_many(:channels).dependent(:destroy) }

  it "defines posting_status with the expected values" do
    expect(described_class.new).to define_enum_for(:posting_status)
      .with_values(unknown: 0, live: 1, expired: 2, closed: 3)
  end

  it { is_expected.to define_enum_for(:priority).with_values(low: 0, medium: 1, high: 2) }

  describe "posting_status independence from our own outcome" do
    it "can be expired while a channel is still awaiting a response" do
      opportunity = create(:opportunity, posting_status: :expired)
      channel = create(:channel, opportunity: opportunity, outcome_status: :sent)

      expect(opportunity.posting_status).to eq("expired")
      expect(channel.outcome_status).to eq("sent")
    end
  end

  describe "#applied?" do
    it "is false when every channel is still a draft" do
      opportunity = create(:opportunity)
      create(:channel, opportunity: opportunity, outcome_status: :draft)

      expect(opportunity.applied?).to be(false)
    end

    it "is true once any channel has moved past draft" do
      opportunity = create(:opportunity)
      create(:channel, opportunity: opportunity, outcome_status: :sent)

      expect(opportunity.applied?).to be(true)
    end
  end

  describe ".without_channels" do
    it "returns opportunities that have no channel at all" do
      researched = create(:opportunity)
      applied_to = create(:opportunity)
      create(:channel, opportunity: applied_to)

      expect(described_class.without_channels).to contain_exactly(researched)
    end
  end
end
