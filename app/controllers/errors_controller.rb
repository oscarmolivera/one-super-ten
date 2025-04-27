class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, :switch_tenant
  skip_after_action :verify_authorized, :verify_policy_scoped

  def not_found
    render plain: "404 Not Found", status: :not_found
  end

  def internal_server_error
    render plain: "500 Internal Server Error", status: :internal_server_error
  end
end