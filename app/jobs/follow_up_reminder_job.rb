# frozen_string_literal: true

# Daily check for channels that were sent FOLLOW_UP_AFTER ago with no
# response since. Reminds the human to follow up — it never contacts the
# employer itself.
class FollowUpReminderJob < ApplicationJob
  queue_as :default

  RECHECK_INTERVAL = 1.day

  def perform(reschedule: true)
    Channel.awaiting_follow_up.find_each do |channel|
      FollowUpMailer.reminder(channel).deliver_later
      RecordChannelEvent.call(
        channel: channel,
        event_type: :follow_up_sent,
        notes: "Automated reminder sent — no response since #{channel.sent_at&.to_date}"
      )
    end

    self.class.set(wait: RECHECK_INTERVAL).perform_later if reschedule
  end
end
