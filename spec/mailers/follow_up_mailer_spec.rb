# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUpMailer, type: :mailer do
  describe "#reminder" do
    let(:organization) { create(:organization, name: "Acme Robotics") }
    let(:opportunity) { create(:opportunity, organization: organization, title: "Frontend Developer") }
    let(:channel) { create(:channel, opportunity: opportunity, channel_type: :email) }
    let(:mail) { described_class.reminder(channel) }

    before { create(:user, email: "demo@example.com") }

    it "addresses the mail to the configured recipient" do
      expect(mail.to).to eq(["demo@example.com"])
    end

    it "mentions the organization and opportunity in the subject" do
      expect(mail.subject).to include("Acme Robotics").and include("Frontend Developer")
    end

    it "includes a link back to the opportunity in the body" do
      expect(mail.body.encoded).to include(opportunity_url(opportunity))
    end
  end
end
