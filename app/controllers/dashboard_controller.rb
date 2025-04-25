class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = policy_scope(User)
  end

  def show
    authorize :dashboard, :show?
    @schedules = current_user.tenant.schedules if current_user.can_view_schedules?
    @appointments = current_user.tenant.citas if current_user.can_manage_appointments?
  end

end