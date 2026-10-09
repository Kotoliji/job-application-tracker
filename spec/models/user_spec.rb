# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }

  it "is invalid without a unique email" do
    create(:user, email: "demo@example.com")
    duplicate = build(:user, email: "demo@example.com")

    expect(duplicate).not_to be_valid
  end
end
