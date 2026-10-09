# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @companies = Organization.company.alphabetical.includes(opportunities: :channels)
    @freelance_clients = Organization.freelance_client.alphabetical.includes(opportunities: :channels)
    @stats = build_stats
    @upcoming_follow_ups =
      Channel.awaiting_follow_up
             .includes(opportunity: :organization)
             .order(:follow_up_at)
  end

  private

  def build_stats
    {
      organizations: Organization.count,
      opportunities: Opportunity.count,
      sent: Channel.where.not(outcome_status: :draft).count,
      interviews: Channel.interview.count,
      offers: Channel.offer.count,
      awaiting_follow_up: Channel.awaiting_follow_up.count
    }
  end
end
