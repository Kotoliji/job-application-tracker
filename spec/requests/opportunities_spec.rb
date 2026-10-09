# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Opportunities", type: :request do
  before { sign_in create(:user) }

  let(:organization) { create(:organization) }

  it "creates an opportunity under its organization" do
    expect do
      post organization_opportunities_path(organization), params: {
        opportunity: { title: "Backend Engineer", track: "full_time" }
      }
    end.to change(Opportunity, :count).by(1)

    expect(Opportunity.last.organization).to eq(organization)
    expect(response).to redirect_to(Opportunity.last)
  end

  it "updates priority and posting_status" do
    opportunity = create(:opportunity, organization: organization, priority: :low)

    patch opportunity_path(opportunity), params: { opportunity: { priority: "high", posting_status: "expired" } }

    opportunity.reload
    expect(opportunity.priority).to eq("high")
    expect(opportunity.posting_status).to eq("expired")
  end
end
