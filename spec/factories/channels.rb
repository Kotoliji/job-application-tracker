# frozen_string_literal: true

FactoryBot.define do
  factory :channel do
    opportunity
    channel_type { :email }
    outcome_status { :draft }
    contact_email { "jobs@example.com" }
    cv_version { "Full-Stack v1" }
  end
end
