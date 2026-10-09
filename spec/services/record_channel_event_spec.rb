# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordChannelEvent do
  let(:channel) { create(:channel, outcome_status: :draft) }

  it "creates a submission event with the given attributes" do
    event = described_class.call(channel: channel, event_type: :sent, notes: "Sent via email")

    expect(event).to be_persisted
    expect(event.event_type).to eq("sent")
    expect(event.notes).to eq("Sent via email")
  end

  it "advances the channel's outcome_status for a status-changing event" do
    described_class.call(channel: channel, event_type: :sent)

    expect(channel.reload.outcome_status).to eq("sent")
  end

  it "schedules a follow-up FOLLOW_UP_AFTER from when it was sent" do
    sent_at = Time.zone.parse("2026-01-01 10:00")

    described_class.call(channel: channel, event_type: :sent, occurred_at: sent_at)

    expect(channel.reload.follow_up_at).to eq(sent_at + Channel::FOLLOW_UP_AFTER)
  end

  it "clears a pending follow-up once a response arrives" do
    described_class.call(channel: channel, event_type: :sent)
    expect(channel.reload.follow_up_at).to be_present

    described_class.call(channel: channel, event_type: :response_received)

    expect(channel.reload.follow_up_at).to be_nil
    expect(channel.outcome_status).to eq("responded")
  end

  it "does not change outcome_status for a purely informational note" do
    described_class.call(channel: channel, event_type: :sent)
    described_class.call(channel: channel, event_type: :note, notes: "Called recruiter, no news yet")

    expect(channel.reload.outcome_status).to eq("sent")
  end

  it "rolls back the event if updating the channel fails" do
    allow(channel).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(channel))

    expect do
      described_class.call(channel: channel, event_type: :sent)
    end.to raise_error(ActiveRecord::RecordInvalid)

    expect(channel.submission_events.count).to eq(0)
  end
end
