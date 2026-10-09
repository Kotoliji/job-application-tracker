# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubmissionEvent, type: :model do
  it { is_expected.to belong_to(:channel) }
  it { is_expected.to validate_presence_of(:occurred_at) }

  describe "#advances_status?" do
    it "is true for an event that maps to a Channel outcome_status" do
      event = build(:submission_event, event_type: :sent)
      expect(event.advances_status?).to be(true)
    end

    it "is false for a purely informational event like a note or follow-up" do
      event = build(:submission_event, event_type: :note)
      expect(event.advances_status?).to be(false)
    end
  end
end
