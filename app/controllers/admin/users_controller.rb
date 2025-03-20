class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user
  
  def index
    @users = policy_scope(User) # 🔹 Enforces tenant scoping via Pundit
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def authorize_user
    authorize User
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end
end