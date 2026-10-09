# frozen_string_literal: true

class ChannelsController < ApplicationController
  before_action :set_opportunity, only: %i[new create]
  before_action :set_channel, only: %i[show edit update destroy]

  def show
    @submission_events = @channel.submission_events.to_a
    @new_event = SubmissionEvent.new(channel: @channel)
  end

  def new
    @channel = @opportunity.channels.new
  end

  def edit; end

  def create
    @channel = @opportunity.channels.new(channel_params)

    if @channel.save
      redirect_to @channel, notice: "Channel added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @channel.update(channel_params)
      redirect_to @channel, notice: "Channel updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    opportunity = @channel.opportunity
    @channel.destroy
    redirect_to opportunity, notice: "Channel removed.", status: :see_other
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:opportunity_id])
  end

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(
      :channel_type, :link, :contact_name, :contact_email, :cv_version, :material
    )
  end
end
