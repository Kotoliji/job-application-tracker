# frozen_string_literal: true

require "rails_helper"

RSpec.describe Channel, type: :model do
  it { is_expected.to belong_to(:opportunity) }
  it { is_expected.to have_many(:submission_events).dependent(:destroy) }

  it "defines channel_type with the expected values" do
    expect(described_class.new).to define_enum_for(:channel_type)
      .with_values(website: 0, email: 1, linkedin: 2, personal_contact: 3, other: 4)
  end

  it "defines outcome_status with the expected values" do
    expect(described_class.new).to define_enum_for(:outcome_status)
      .with_values(draft: 0, sent: 1, viewed: 2, responded: 3, interview: 4, rejected: 5, offer: 6)
  end

  describe ".awaiting_follow_up" do
    it "includes a sent channel whose follow-up date has passed" do
      channel = create(:channel, outcome_status: :sent, follow_up_at: 1.day.ago)

      expect(described_class.awaiting_follow_up).to include(channel)
    end

    it "excludes a sent channel whose follow-up date is still in the future" do
      channel = create(:channel, outcome_status: :sent, follow_up_at: 1.day.from_now)

      expect(described_class.awaiting_follow_up).not_to include(channel)
    end

    it "excludes a channel that already has a response, even past the follow-up date" do
      channel = create(:channel, outcome_status: :responded, follow_up_at: nil)

      expect(described_class.awaiting_follow_up).not_to include(channel)
    end
  end
end
