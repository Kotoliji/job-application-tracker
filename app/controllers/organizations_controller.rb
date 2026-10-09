# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]

  def index
    @organizations = Organization.alphabetical
  end

  def show
    @opportunities = @organization.opportunities.includes(:channels).order(priority: :desc, created_at: :desc)
  end

  def new
    @organization = Organization.new
  end

  def edit; end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization, notice: "Organization added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: "Organization removed.", status: :see_other
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :kind, :location, :website, :notes)
  end
end
