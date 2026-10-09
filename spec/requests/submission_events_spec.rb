# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SubmissionEvents", type: :request do
  before { sign_in create(:user) }

  it "records an event through the HTTP layer and advances the channel's status" do
    channel = create(:channel, outcome_status: :draft)

    post channel_submission_events_path(channel), params: {
      submission_event: { event_type: "sent", occurred_at: Time.current, notes: "Sent via email" }
    }

    expect(response).to redirect_to(channel_path(channel))
    expect(channel.reload.outcome_status).to eq("sent")
    expect(channel.submission_events.last.notes).to eq("Sent via email")
  end
end
