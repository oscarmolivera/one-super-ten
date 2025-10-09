class ExternalMatchesController < ApplicationController
  before_action :set_tournament
  before_action :set_season_team

  def index
    authorize :external_match, :index?
    @external_matches = @tournament.external_matches.order(match_date: :desc)
  end

  def new
    @external_match = ExternalMatch.new
    authorize :external_match, :index?
    respond_to do |format|
      format.html { render partial: "external_matches/modal", locals: { external_match: @external_match, season_team: @season_team, tournament: @tournament } }
    end
  end

  def create
    authorize :external_match, :index?
    @external_match = @tournament.external_matches.build(external_match_params)
    @external_match.tenant = @tournament.tenant
    @tournament_data = tournament_data
    
    if @external_match.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

    def edit
      authorize :external_match, :index?
      @external_match = @tournament.external_matches.build
    end

    def update
      authorize :external_match, :index?
      @external_match = @tournament.external_matches.build(external_match_params)
      if @external_match.update(external_match_params)
        respond_to do |format|
          format.html { redirect_to tournament_path(@tournament), notice: "Result added." }
          format.turbo_stream  # Renders app/views/external_matches/update.turbo_stream.erb
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

  private

  def set_tournament
    @tournament = SeasonTeam.find(params[:id]).tournament unless @tournament
  end

  def set_season_team
    @season_team = SeasonTeam.find(params[:id]) unless @season_team
  end

  def external_match_params
    params.require(:external_match).permit(
      :tournament_id, :home_rival_id, :away_rival_id, :home_score, :away_score,
      :stage_id, :match_date, :match_time, :status, :notes
    )
  end

  def tournament_data
    authorize :external_match, :index?
    @tournament_data = SeasonTeams::TournamentDataService.new(@season_team, nil, nil).data
  end
end