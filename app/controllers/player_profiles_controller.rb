class PlayerProfilesController < ApplicationController
  before_action :set_player
  before_action :set_profile
  before_action :authorize_profile

  def show; end

  def edit; end

  def update
    if @profile.update(player_profile_params)
      redirect_to player_profile_path(@player), notice: "Perfil actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def set_profile
    @profile = @player.player_profile || @player.build_player_profile
  end

  def authorize_profile
    authorize :player_profile, :index?
  end

  def player_profile_params
    params.require(:player_profile).permit(
      :jersey_number, :nickname, :internal_notes, :status,
      :disciplinary_flag, :skill_rating,  social_links: {}
    )
  end
end
