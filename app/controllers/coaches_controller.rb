class CoachesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coach, only: [:show, :edit, :update, :destroy]

  def index
    authorize :coach, :index?
    @coaches = policy_scope(User).with_role(:coach, ActsAsTenant.current_tenant).includes(:coach_profile, :categories)
  end

  def show
  end

  def new
    @coach = User.new
    @coach.build_coach_profile
    authorize :coach, :new?
  end

  def create
    authorize :coach, :create?
    @coach = User.new(coach_params)
    @coach.tenant = ActsAsTenant.current_tenant
    if @coach.save
      @coach.add_role(:coach, ActsAsTenant.current_tenant)
      redirect_to coaches_path, notice: "Coach created successfully."
    else
      render :new
    end
  end

  def edit
    authorize :coach, :index?
    @coach.build_coach_profile unless @coach.coach_profile
  end

  def update
    authorize :coach, :index?
    if @coach.update(filtered_params)
      redirect_to coaches_path, notice: "Coach updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @coach.destroy
    redirect_to coaches_path, notice: "Coach deleted."
  end

  def assistants
    @coach = User.find(params[:id])
    authorize :coach, :index?

    @available_assistants = User
      .with_role(:assistant_coach, ActsAsTenant.current_tenant)
      .where.not(id: @coach.assistants.pluck(:id))
  end

  def assign_assistant
    @coach = User.find(params[:id])
    assistant = User.find(params[:assistant_id])
    authorize :coach, :index?


    if !@coach.assistants.include?(assistant)
      @coach.assistants << assistant
      flash[:notice] = "#{assistant.full_name} assigned."
    else
      flash[:alert] = "Already assigned."
    end

    redirect_to coaches_path
  end

  def remove_assistant
    @coach = User.find(params[:id])
    assistant = User.find(params[:assistant_id])
    authorize :coach, :index?

    @coach.assistants.destroy(assistant)

    flash[:notice] = "Assistant removed."
    redirect_to assistants_coach_path(@coach)
  end

  private

  def set_coach
    @coach = User.with_role(:coach, ActsAsTenant.current_tenant).find(params[:id])
  end

  def coach_params
    params.require(:user).permit(
      :email, :password, :first_name, :last_name,
      coach_profile_attributes: [:hire_date, :salary]
    )
  end

  def filtered_params
    filtered = coach_params
    filtered.delete(:password) if filtered_params[:password].blank?
    filtered
  end
end