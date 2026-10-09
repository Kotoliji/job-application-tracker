# frozen_string_literal: true

FactoryBot.define do
  factory :opportunity do
    organization
    sequence(:title) { |n| "Frontend Developer #{n}" }
    requirements { "Vue, TypeScript" }
    track { :full_time }
    priority { :medium }
    posting_status { :live }
    found_at { 10.days.ago.to_date }
    checked_at { 1.day.ago.to_date }
  end
end
