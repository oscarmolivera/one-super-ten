class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize :user, :index?
    @users = policy_scope(User)
  end

  def show
    authorize :user, :show?
  end

  def new
    @user = User.new  
    authorize :user, :new?
  end

  def create
    authorize :user, :create?
    @user = User.new(user_params)
    @user.tenant = ActsAsTenant.current_tenant
    if @user.save
      @user.add_role(:user, ActsAsTenant.current_tenant)
      redirect_to users_path, notice: "User created successfully."
    else
      render :new
    end
  end

  def edit
    authorize :user, :index?
    @category_team_assistant = CategoryTeamAssistant.new
  end

  def update
    authorize :user, :index?
    if @user.update(filtered_params)
      redirect_to users_path, notice: "Coach updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "Coach deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, :password, :first_name, :last_name
    )
  end

  def filtered_params
    filtered = user_params
    filtered.delete(:password) if filtered[:password].blank?
    filtered
  end
end