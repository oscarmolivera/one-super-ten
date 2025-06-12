class ExternalPlayersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :external_player, :index?
    @players = policy_scope(ExternalPlayer)
  end

  def show
    authorize :external_player, :index?

    player = ExternalPlayer.find_by(id: params[:id])
    if player
      render json: player.slice(:id, :first_name, :last_name, :jersey_number, :position, :date_of_birth)
    else
      render json: { error: "Jugador no encontrado" }, status: :not_found
    end
  end

  def new
    authorize :external_player, :index?
    @external_player = ExternalPlayer.new
  end

  def create
    authorize :event, :index?
    @ext_player = ExternalPlayer.new(external_player_params)
    if @ext_player.save
      redirect_to external_players_path, notice: "Event created"
    else
      render :new
    end
  end

  def edit
    authorize :external_player, :index?

    @external_player = ExternalPlayer.find_by(id: params[:id])
  end

  def update
    authorize :external_player, :index?
    @external_player = ExternalPlayer.find_by(id: params[:id])
    if @external_player.update(external_player_params)
      redirect_to external_players_path, notice: "Ingreso actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize :external_player, :index?

    player = ExternalPlayer.find_by(id: params[:id])
    if player
      player.destroy
      render json: { message: "Jugador eliminado exitosamente" }, status: :ok
    else
      render json: { error: "Jugador no encontrado" }, status: :not_found
    end
  end

  private

  def external_player_params
    params.require(:external_player).permit(
      :tenant_id, :user_id, :first_name, :last_name, :position, :jersey_number, 
      :document_number, :date_of_birth, :gender, :notes, :is_active
    )
  end
end
