# frozen_string_literal: true

class SubmissionEvent < ApplicationRecord
  belongs_to :channel

  enum :event_type, {
    draft_prepared: 0,
    sent: 1,
    viewed: 2,
    response_received: 3,
    interview_scheduled: 4,
    rejected: 5,
    offer_received: 6,
    follow_up_sent: 7,
    note: 8
  }

  # event types that move a Channel's outcome_status forward
  STATUS_FOR_EVENT = {
    "sent" => "sent",
    "viewed" => "viewed",
    "response_received" => "responded",
    "interview_scheduled" => "interview",
    "rejected" => "rejected",
    "offer_received" => "offer"
  }.freeze

  validates :event_type, presence: true
  validates :occurred_at, presence: true

  def advances_status?
    STATUS_FOR_EVENT.key?(event_type)
  end
end
