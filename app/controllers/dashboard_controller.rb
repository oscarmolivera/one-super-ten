class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :dashboard, :index?
    @users = policy_scope(User)
  end
end