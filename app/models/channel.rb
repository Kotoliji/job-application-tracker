# frozen_string_literal: true

class Channel < ApplicationRecord
  FOLLOW_UP_AFTER = 6.days

  belongs_to :opportunity
  has_many :submission_events, -> { order(occurred_at: :asc) }, dependent: :destroy, inverse_of: :channel
  has_one_attached :material

  enum :channel_type, { website: 0, email: 1, linkedin: 2, personal_contact: 3, other: 4 }, default: :email

  # Our own outcome on this specific channel — independent from whether the
  # underlying Opportunity posting is still live, expired or closed.
  enum :outcome_status, {
    draft: 0,
    sent: 1,
    viewed: 2,
    responded: 3,
    interview: 4,
    rejected: 5,
    offer: 6
  }, default: :draft

  validates :channel_type, presence: true

  scope :awaiting_follow_up, -> { sent.where(follow_up_at: ..Time.current) }

  def latest_event
    submission_events.last
  end
end
