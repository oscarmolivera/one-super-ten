class CategoryTeamAssistantsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    @category_team_assistant = CategoryTeamAssistant.new(category_team_assistant_params)
    authorize :category_team_assistant, :create?
    binding.pry
    if @category_team_assistant.save
      redirect_to edit_user_path(@category_team_assistant.user), notice: "Assistant assigned to category."
    else
      redirect_back fallback_location: users_path, alert: "Assignment failed: #{@category_team_assistant.errors.full_messages.to_sentence}"
    end
  end

  private

  def category_team_assistant_params
    params.require(:category_team_assistant).permit(:user_id, :category_id)
  end
end