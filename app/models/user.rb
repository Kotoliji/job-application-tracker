# frozen_string_literal: true

class User < ApplicationRecord
  # No :registerable — this app has one shared, unscoped dataset (your own
  # job search), not per-user data. Self-signup would let anyone who finds
  # the deployed app read everything. Create users via `bin/rails db:seed`
  # or the console instead.
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
