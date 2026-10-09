# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Authentication", type: :request do
  it "redirects an anonymous visitor to sign in" do
    get root_path

    expect(response).to redirect_to(new_user_session_path)
  end

  it "lets a signed-in user reach the dashboard" do
    sign_in create(:user)

    get root_path

    expect(response).to have_http_status(:ok)
  end

  it "does not expose a self-service sign-up page" do
    get "/users/sign_up"

    expect(response).to have_http_status(:not_found)
  end
end
