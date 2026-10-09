# frozen_string_literal: true

FactoryBot.define do
  factory :submission_event do
    channel
    event_type { :sent }
    occurred_at { Time.current }
  end
end
