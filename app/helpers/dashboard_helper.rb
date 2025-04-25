module DashboardHelper
  def dashboard_widgets
    case current_user.role
    when 'coach'
      render 'coach_widgets'
    when 'staff_assistant'
      render 'staff_assistant_widgets'
    else
      '' # Fallback for unexpected roles
    end
  end

  def tenant_greeting
    "Welcome to #{current_user.tenant.name}'s Dashboard"
  end
end