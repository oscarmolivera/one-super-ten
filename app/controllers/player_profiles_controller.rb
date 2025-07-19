class PlayerProfilesController < ApplicationController
  before_action :set_player
  before_action :set_profile
  before_action :set_teammates, only: [:show]
  before_action :authorize_profile

  def new
    @profile = @player.build_player_profile
    @profile.status = :active
    @profile.disciplinary_flag = :none
    @profile.skill_rating = :none
    @profile.social_links = {}
  end
  
  def create
    @profile = @player.build_player_profile(player_profile_params)
    @profile.status = :active
    @profile.disciplinary_flag = :none
    @profile.skill_rating = :none
    @profile.social_links = {}
    @profile.jersey_number = @player.players_count + 1
    if @profile.save
      redirect_to player_profile_path(@player), notice: "Perfil creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @player = Player.find(params[:id])

    profile_attrs = player_params[:player_profile_attributes]

    if profile_attrs
      social_links = {
        "facebook" => profile_attrs.delete(:social_links_facebook),
        "instagram" => profile_attrs.delete(:social_links_instagram),
        "tiktok" => profile_attrs.delete(:social_links_tiktok)
      }

      profile_attrs[:social_links] = social_links
      @player.build_player_profile unless @player.player_profile
      @player.player_profile.assign_attributes(profile_attrs)
    end
    if @player.update(player_params.except(:player_profile_attributes))
      @player.player_profile.save if profile_attrs
      redirect_to @player, notice: "Jugador actualizado correctamente."
    else
      render :edit
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

  def set_teammates
    authorize :player_profile, :index?
    @player = Player.find(params[:player_id])

    category = @player.categories.first

    @teammates = category.players
  end

  def player_profile_params
    params.require(:player_profile).permit(
      :jersey_number, :nickname, :internal_notes, :status,
      :disciplinary_flag, :skill_rating, social_links: %i[facebook instagram tiktok]
    )
  end
end
