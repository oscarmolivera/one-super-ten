class ExternalPlayersController < ApplicationController
  def create
    player = ExternalPlayer.new(external_player_params)

    if player.save
      render json: player.slice(:id, :first_name, :last_name, :jersey_number, :position, :date_of_birth)
    else
      render json: { error: "No se pudo crear el jugador" }, status: :unprocessable_entity
    end
  end

  private

  def external_player_params
    params.require(:new_external_player).permit(
      :first_name, :last_name, :position, :jersey_number, :document_number,
      :date_of_birth, :gender, :notes
    )
  end
end