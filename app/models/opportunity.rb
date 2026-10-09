# frozen_string_literal: true

class Opportunity < ApplicationRecord
  belongs_to :organization

  has_many :channels, dependent: :destroy
  has_many :submission_events, through: :channels

  # Whether the posting itself is still available — independent from how our
  # own applications on it are going. An expired posting does not mean we
  # were rejected; a live posting does not mean anyone is reviewing us.
  enum :posting_status, { unknown: 0, live: 1, expired: 2, closed: 3 }, default: :unknown

  enum :priority, { low: 0, medium: 1, high: 2 }, default: :medium

  enum :track, { full_time: 0, internship: 1, freelance_contract: 2, program: 3 }, default: :full_time

  validates :title, presence: true

  scope :without_channels, -> { where.missing(:channels) }
  scope :high_priority, -> { where(priority: :high) }

  def applied?
    channels.any? { |channel| !channel.draft? }
  end
end
