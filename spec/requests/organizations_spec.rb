# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Organizations", type: :request do
  before { sign_in create(:user) }

  it "creates an organization and redirects to it" do
    expect do
      post organizations_path, params: { organization: { name: "Acme Corp", kind: "company" } }
    end.to change(Organization, :count).by(1)

    expect(response).to redirect_to(Organization.last)
  end

  it "rejects a blank name with a 422 and no record created" do
    expect do
      post organizations_path, params: { organization: { name: "" } }
    end.not_to change(Organization, :count)

    expect(response).to have_http_status(:unprocessable_content)
  end

  it "destroys an organization and its opportunities" do
    organization = create(:organization)
    opportunity = create(:opportunity, organization: organization)

    expect do
      delete organization_path(organization)
    end.to change(Organization, :count).by(-1).and change(Opportunity, :count).by(-1)

    expect(Opportunity.exists?(opportunity.id)).to be(false)
  end
end
