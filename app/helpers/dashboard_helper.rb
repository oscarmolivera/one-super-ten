module DashboardHelper
  def dynamic_dashboard_content_wrapper
    return 'shared/dashboard/default_dashboard' unless current_user

    partial_name = "#{current_user.role_name}_dashboard".downcase
    "shared/dashboard/#{partial_name}"
  rescue
    'shared/dashboard/default_dashboard'
  end
end