# frozen_string_literal: true

class OpportunitiesController < ApplicationController
  before_action :set_organization, only: %i[new create]
  before_action :set_opportunity, only: %i[show edit update destroy]

  def index
    @opportunities = Opportunity.includes(:organization, :channels).order(priority: :desc, created_at: :desc)
  end

  def show
    @channels = @opportunity.channels.includes(:submission_events)
  end

  def new
    @opportunity = @organization.opportunities.new
  end

  def edit; end

  def create
    @opportunity = @organization.opportunities.new(opportunity_params)

    if @opportunity.save
      redirect_to @opportunity, notice: "Opportunity added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @opportunity.update(opportunity_params)
      redirect_to @opportunity, notice: "Opportunity updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    organization = @opportunity.organization
    @opportunity.destroy
    redirect_to organization, notice: "Opportunity removed.", status: :see_other
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def opportunity_params
    params.require(:opportunity).permit(
      :title, :requirements, :product_description, :source_url,
      :found_at, :checked_at, :deadline, :posting_status, :priority, :track
    )
  end
end
