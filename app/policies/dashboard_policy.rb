class DashboardPolicy < ApplicationPolicy

  def index?
    current_user  
  end

  def show?
    user.has_role?(:coach) || user.has_role?(:staff_assistant)
  end
end