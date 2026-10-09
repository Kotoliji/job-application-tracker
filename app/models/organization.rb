# frozen_string_literal: true

class Organization < ApplicationRecord
  enum :kind, { company: 0, freelance_client: 1 }, default: :company

  has_many :opportunities, dependent: :destroy
  has_many :channels, through: :opportunities

  validates :name, presence: true

  scope :alphabetical, -> { order(:name) }
end
