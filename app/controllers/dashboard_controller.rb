class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :dashboard, :index?
    @users = policy_scope(User)
  end

  def show
    authorize :dashboard, :show?
    if current_user.has_role?(:coach)
      @message = "Welcome Coach!"
    elsif current_user.has_role?(:staff_assistant)
      @message = "Welcome Staff Assistant!"
    else
      @message = "Welcome!"
    end
  end
end