class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_superadmin!

  private

  def ensure_superadmin!
    unless current_user&.superadmin?
      redirect_to root_path, alert: "Access denied"
    end
  end
end