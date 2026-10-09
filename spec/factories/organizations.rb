# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Acme #{n}" }
    kind { :company }
    location { "Coimbra, PT" }
    website { "https://example.com" }

    trait :freelance_client do
      kind { :freelance_client }
    end
  end
end
