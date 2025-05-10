class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schools, only: %i[edit new]
  before_action :set_site, only: %i[show edit update destroy]

  def index
    authorize :site, :index?
    @sites = policy_scope(Site)
  end

  def show; end

  def new
    authorize :site, :index?
    @site = Site.new
  end
  
  def edit
    authorize :site, :index?
  end
  
  def create
    authorize :site, :index?
    @site = Site.new(site_params)
    @site.tenant = ActsAsTenant.current_tenant if Site.column_names.include?('tenant_id')

    if @site.save
      redirect_to sites_path, notice: "Site created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize :site, :index?
    if @site.update(site_params)
      redirect_to sites_path, notice: "Site updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @site.destroy
    redirect_to sites_path, notice: "Site deleted."
  end

  private

  def allow_user
    authorize :site, :index?
  end

  def set_schools
    @schools = School.where(tenant: ActsAsTenant.current_tenant)
  end

  def set_site
    @site = Site.find(params[:id])
  end

  def site_params
    params
      .require(:site)
      .permit(
        :school_id,
        :name, 
        :address, 
        :city, 
        :capacity, 
        :description
      )
  end
end