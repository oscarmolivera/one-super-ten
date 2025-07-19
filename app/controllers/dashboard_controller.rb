class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :dashboard, :index?
    @users = policy_scope(User)
    redirect_to player_player_profile_path(current_user.player) if current_user.has_role_player?
    redirect_to coach_path(current_user) if current_user.has_role_coach?
  end
end