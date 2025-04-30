class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :edit, :update]
  before_action :set_category, only: []

  def index
    authorize :player, :index?
    @players = policy_scope(Player)
  end

  def show
    authorize :player, :index?
  end

  def new
    authorize :player, :index?
    @player = Player.new
  end

  def create
    authorize :player, :index?
    @player = Player.new(player_params)
    if @player.save
      redirect_to players_path, notice: "Player created successfully."
    else
      render :new
    end
  end

  def edit
    authorize :player, :index?
  end

  def update
    authorize :player, :index?
    if @player.update(player_params)
      redirect_to players_path, notice: "Player updated successfully."
    else
      render :edit
    end
  end

def destroy
  authorize :player, :destroy?
  if @player.destroy
    respond_to do |format|
      format.html { redirect_to players_path, notice: "Player deleted." }
      format.turbo_stream
    end
  else
    respond_to do |format|
      format.html { redirect_to players_path, alert: "Failed to delete player: #{@player.errors.full_messages.join(', ')}" }
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("messages", partial: "shared/flash", locals: { alert: "Failed to delete player: #{@player.errors.full_messages.join(', ')}" })
      end
    end
  end
end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def set_school
    @schools = ActsAsTenant.current_tenant.schools
  end

  def set_category
    @categories = @schools.categories
  end

  def player_params
    params.require(:player).permit(
      :email, :tenant_id, :category_id, :first_name, :last_name, :full_name,
      :date_of_birth, :gender, :nationality, :document_number, :profile_picture,
      :dominant_side, :position, :address, :is_active, :bio, :notes, :user_id
    )
  end
end
