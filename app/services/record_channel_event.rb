# frozen_string_literal: true

# Records one step in a Channel's history (sent, viewed, interview, ...) and
# keeps Channel#outcome_status / #follow_up_at in sync with that history.
#
# Sending is always a human action performed outside this app (email client,
# a job site's own form, LinkedIn). This service only records what already
# happened — it never sends anything itself.
class RecordChannelEvent
  def self.call(...)
    new(...).call
  end

  def initialize(channel:, event_type:, occurred_at: Time.current, notes: nil)
    @channel = channel
    @event_type = event_type
    @occurred_at = occurred_at
    @notes = notes
  end

  def call
    event = nil

    ActiveRecord::Base.transaction do
      event = channel.submission_events.create!(
        event_type: event_type,
        occurred_at: occurred_at,
        notes: notes
      )

      apply_status_change(event)
      apply_follow_up_schedule(event)

      channel.save!
    end

    event
  end

  private

  attr_reader :channel, :event_type, :occurred_at, :notes

  def apply_status_change(event)
    new_status = SubmissionEvent::STATUS_FOR_EVENT[event.event_type]
    channel.outcome_status = new_status if new_status
  end

  def apply_follow_up_schedule(event)
    case event.event_type
    when "sent"
      channel.sent_at = event.occurred_at
      channel.follow_up_at = event.occurred_at + Channel::FOLLOW_UP_AFTER
    when "viewed", "response_received", "interview_scheduled", "rejected", "offer_received", "follow_up_sent"
      # any later signal means the pending follow-up no longer applies
      channel.follow_up_at = nil
    end
  end
end
