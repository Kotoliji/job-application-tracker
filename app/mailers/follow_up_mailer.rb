# frozen_string_literal: true

class FollowUpMailer < ApplicationMailer
  def reminder(channel)
    @channel = channel
    @opportunity = channel.opportunity
    @organization = @opportunity.organization

    mail(to: recipient, subject: "Follow up: #{@organization.name} — #{@opportunity.title}")
  end

  private

  def recipient
    ENV.fetch("NOTIFY_EMAIL") { User.first&.email || "you@example.com" }
  end
end
