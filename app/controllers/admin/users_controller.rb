class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.where(tenant_id: current_user.tenant_id) # Only users in this tenant
  end

  def show
    @user = current_tenant.users.find(params[:id])
  end

  def edit
    @user = current_tenant.users.find(params[:id])
  end

  def update
    @user = current_tenant.users.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @user = current_tenant.users.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end

  def current_tenant
    Tenant.find_by(subdomain: request.subdomain)
  end
end
