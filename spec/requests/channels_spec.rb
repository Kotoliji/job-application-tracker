# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Channels", type: :request do
  before { sign_in create(:user) }

  let(:opportunity) { create(:opportunity) }

  it "creates a channel under its opportunity" do
    expect do
      post opportunity_channels_path(opportunity), params: {
        channel: { channel_type: "linkedin", contact_name: "Jane Recruiter" }
      }
    end.to change(Channel, :count).by(1)

    expect(Channel.last.opportunity).to eq(opportunity)
  end

  it "attaches a material file to a channel" do
    channel = create(:channel, opportunity: opportunity)
    file = fixture_file_upload("sample_cv.txt", "text/plain")

    patch channel_path(channel), params: { channel: { channel_type: "email", material: file } }

    expect(channel.reload.material).to be_attached
    expect(channel.material.filename.to_s).to eq("sample_cv.txt")
  end

  it "shows a channel's recorded history in chronological order" do
    channel = create(:channel, opportunity: opportunity)
    RecordChannelEvent.call(channel: channel, event_type: :sent, occurred_at: 2.days.ago)
    RecordChannelEvent.call(channel: channel, event_type: :viewed, occurred_at: 1.day.ago)

    get channel_path(channel)

    expect(response.body).to include("Sent").and include("Viewed")
  end
end
