class AssistantsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :assistant, :index?
    @assistants = policy_scope(User).with_role(:assistant_coach, ActsAsTenant.current_tenant).includes(:coach_profile, :categories)
    @coaches = policy_scope(User).with_role(:coach, ActsAsTenant.current_tenant).includes(:coach_profile, :categories)
  end

  def assign_coach
    authorize :assistant, :index?
    assistant = User.find(params[:assistant_id])
    coach = User.find(params[:coach_id])
    unless assistant.coaches.include?(coach)
      assistant.coaches << coach
      flash[:notice] = "#{coach.full_name} assigned to #{assistant.full_name}."
    else
      flash[:alert] = "Already assigned."
    end
    redirect_to assistants_path
  end

  def remove_coach
    authorize :assistant, :index?

    assistant = User.find(params[:assistant_id])
    coach = User.find(params[:coach_id])
    assistant.coaches.destroy(coach)
    flash[:notice] = "Removed #{coach.full_name} from #{assistant.full_name}."
    redirect_to assistants_path
  end

  def edit
    authorize :assistant, :index?

    @assistant = User.find(params[:id])
  end

  def update
    authorize :assistant, :index?

    @assistant = User.find(params[:id])
    if @assistant.update(assistant_params)
      flash[:notice] = "Assistant updated successfully."
      redirect_to assistants_path
    else
      flash.now[:alert] = "Could not update assistant."
      render :edit
    end
  end

  private

  def assistant_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end