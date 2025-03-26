class DashboardController < ApplicationController
  def index
    @users = policy_scope(User)
  end
end