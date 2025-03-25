class LandingsController < ApplicationController
  before_action :set_landing, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [:index]
  
  def index
    @landings = policy_scope(Landing)
  end
  
  def show
    authorize @landing
  end

  def new
    @landing = Landing.new
    authorize @landing
  end

  def edit
    authorize @landing
  end

  def create
    @landing = Landing.new(landing_params)
    @landing.tenant_id = ActsAsTenant.current_tenant.id # 🔹 Ensure the landing belongs to the current tenant
    authorize @landing

    respond_to do |format|
      if @landing.save
        format.html { redirect_to @landing, notice: "Landing was successfully created." }
        format.json { render :show, status: :created, location: @landing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @landing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @landing

    respond_to do |format|
      if @landing.update(landing_params)
        format.html { redirect_to @landing, notice: "Landing was successfully updated." }
        format.json { render :show, status: :ok, location: @landing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @landing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @landing
    @landing.destroy!

    respond_to do |format|
      format.html { redirect_to landings_path, status: :see_other, notice: "Landing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_landing
    @landing = Landing.find(params.require(:id))
  end

  def landing_params
    params.require(:landing).permit(:title, :description, :published)
  end
end
