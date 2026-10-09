# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUpReminderJob, type: :job do
  include ActiveJob::TestHelper

  it "sends a reminder for a channel whose follow-up date has passed" do
    channel = create(:channel, outcome_status: :sent, follow_up_at: 1.day.ago)

    expect do
      perform_enqueued_jobs { described_class.perform_now(reschedule: false) }
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    expect(channel.reload.outcome_status).to eq("sent")
    expect(channel.submission_events.pluck(:event_type)).to include("follow_up_sent")
  end

  it "does not notify twice for the same pending follow-up" do
    create(:channel, outcome_status: :sent, follow_up_at: 1.day.ago)

    perform_enqueued_jobs { described_class.perform_now(reschedule: false) }
    perform_enqueued_jobs { described_class.perform_now(reschedule: false) }

    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it "ignores channels that are not awaiting a follow-up" do
    create(:channel, outcome_status: :draft)
    create(:channel, outcome_status: :sent, follow_up_at: 1.day.from_now)

    expect do
      perform_enqueued_jobs { described_class.perform_now(reschedule: false) }
    end.not_to(change { ActionMailer::Base.deliveries.count })
  end

  it "reschedules itself to run again in a day by default" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(described_class).at(a_value_within(5).of(1.day.from_now))
  end

  it "does not reschedule itself when called with reschedule: false" do
    expect do
      described_class.perform_now(reschedule: false)
    end.not_to have_enqueued_job(described_class)
  end
end
