class SeasonTeam::RivalsController < ApplicationController
  before_action :set_season_team
  before_action :authorize_rivals
  before_action :set_rival, only: %i[edit update destroy]

  def index
    @rivals = @season_team.rivals
    @rival  = Rival.new                  # for inline “new” modal/form
  end

  def create
    @rival = Rival.new(rival_params)
    if @rival.save
      @season_team.rivals << @rival
      redirect_to tournament_data_season_team_path(@season_team), notice: "Rival agregado."
    else
      @rivals = @season_team.rivals
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @rival.update(rival_params)
      redirect_to tournament_data_season_team_path(@season_team), notice: "Rival actualizado."
    else
      @rivals = @season_team.rivals
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @season_team.rivals.destroy(@rival)
    redirect_to tournament_data_season_team_path(@season_team), notice: "Rival eliminado."
  end

  private

  def set_season_team
    @season_team = SeasonTeam.find(params[:id])
  end

  def set_rival
    @rival = Rival.find(params[:id])
  end

  def rival_params
    params.require(:rival).permit(:name, :location, :logo)
  end

  def authorize_rivals
    authorize :rival, :index?
  end
end