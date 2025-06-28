class SeasonTeams::MatchesController < ApplicationController
  before_action :set_match, only: %i[show update_performances]
  before_action :set_season_team, only: [:create]
  
  def index
    @category = Category.find(params[:category_id])
    matches = @category.matches.includes(:call_ups).order(scheduled_at: :desc)
    @matches = policy_scope(matches)
  end

  def show
    authorize :match, :index?
    @line_ups = @match.line_ups.includes(call_up_player: :player)
  end

  def update_performances
    authorize :match, :index?

    params[:performances].each do |id, attrs|
      perf = @match.match_performances.find(id)
      perf.update(attrs.permit(:minutes_played, :goals, :assists, :yellow_cards, :red_cards, :notes))
    end

    redirect_to match_path(@match), notice: "Player performances updated."
  end

  def new
    @match = Match.new
    authorize :match, :index?
    @category = Category.find_by(id: params[:category_id]) if params[:category_id]
  end

  def create
    authorize :match, :index?
    @season_team = SeasonTeam.find(params[:season_team_id])
    @match = Match.new(match_params)
    @match.tenant = ActsAsTenant.current_tenant
  
    respond_to do |format|
      if @match.save
        @tournament_data = SeasonTeams::TournamentDataService.new(@season_team, nil, nil).data
  
        format.turbo_stream
        format.html { redirect_back fallback_location: tournament_data_season_team_path(@season_team), notice: "Partido creado." }
      else
        format.turbo_stream
        format.html { redirect_back fallback_location: tournament_data_season_team_path(@season_team), alert: "Error al crear partido." }
      end
    end
  end

  private

  def match_params
    params.require(:match).permit(
      :tenant_id, :tournament_id, :team_of_interest_id, :rival_season_team_id, 
      :rival_id, :plays_as, :match_type, :location, :location_type, :status, 
      :scheduled_at, :home_score, :away_score, :notes, 
    )
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def set_season_team
    @season_team = SeasonTeam.find(params[:season_team_id])
  end
end
