module DashboardHelper
  def dashboard_widgets
    case current_user.role_name
    when 'tenant_admin'
      render 'shared/dashboard/coach_widgets'
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