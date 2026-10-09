# frozen_string_literal: true

class SubmissionEventsController < ApplicationController
  before_action :set_channel

  def create
    RecordChannelEvent.call(
      channel: @channel,
      event_type: event_params[:event_type],
      occurred_at: event_params[:occurred_at].presence || Time.current,
      notes: event_params[:notes]
    )

    redirect_to @channel, notice: "Event recorded."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @channel, alert: e.message
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def event_params
    params.require(:submission_event).permit(:event_type, :occurred_at, :notes)
  end
end
