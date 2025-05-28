class CupsController < ApplicationController
  before_action :set_cup, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    authorize :cup, :index?
    @cups = policy_scope(Cup)
    @schools = School.where(tenant: ActsAsTenant.current_tenant)
    @selected_school = @schools.first
  end

  def new
    authorize :cup, :index?

    @cup = Cup.new
    @cup.school_id = params[:school_id] if params[:school_id].present?
  end

  def create
    authorize :cup, :index?

    @cup = Cup.new(cup_params)
    @cup.tenant = ActsAsTenant.current_tenant

    if @cup.save
      redirect_to cups_path, notice: 'Copa creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize :cup, :index?
  end

  def update
    authorize :cup, :index?

    if @cup.update(cup_params)
      redirect_to cups_path, notice: 'Copa actualizada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_cup
    @cup = Cup.find(params[:id])
  end

  def cup_params
    params.require(:cup).permit(:name, :logo, :school_id)
  end
end