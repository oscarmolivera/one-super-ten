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
      perf.update(attrs.permit(
        :id,
        :performer_type, :performer_id,  # keep polymorphic
        :goals_scored, :assists, :minute_of_event,
        :yellow_cards, :red_cards, :notes,
        :tournament_id, :tenant_id
      ))
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

  def update
    authorize :match, :index?
    @match = Match.find(params[:id])
    @season_team = @match.team_of_interest

    if @match.update(filtered_match_params)
      @tournament_data = SeasonTeams::TournamentDataService.new(@season_team, nil, nil).data
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tournament_data_season_team_path(@season_team), notice: "Partido actualizado correctamente." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "edit_match_modal_frame_#{@match.id}",
            partial: "season_teams/matches/modal",
            locals: { match: @match, season_team: @season_team }
          )
        end
        format.html do
          flash.now[:alert] = "Error al actualizar el partido."
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def performance_form
    authorize :match, :index?
    @match = Match.find(params[:id])
    @season_team = @match.team_of_interest
    render partial: "season_teams/matches/performance_form", locals: { match: @match, season_team: @season_team }
  end

  private

  # Strip out empty/zeroed performances before updating the match
  def filtered_match_params
    p = match_params.deep_dup

    attrs = p[:match_performances_attributes]
    if attrs.is_a?(ActionController::Parameters) || attrs.is_a?(Hash)
      attrs.to_h.each do |key, h|
        a = h.is_a?(ActionController::Parameters) ? h.to_unsafe_h : h

        counters = %w[goals_scored assists yellow_cards red_cards minute_of_event]

        all_zero = counters.all? { |k| a[k].to_i.zero? }
        notes_blank = a["notes"].to_s.strip.empty?

        attrs.delete(key) if all_zero && notes_blank
      end
    end

    p
  end

def match_params
  params.require(:match).permit(
    :tenant_id, :tournament_id, :team_of_interest_id, :rival_season_team_id,
    :rival_id, :plays_as, :match_type, :location, :location_type, :status,
    :stage_id, :referee, :scheduled_at, :team_score, :rival_score, :notes,
    match_performances_attributes: [ :id, :performer_type, :performer_id, 
      :goals_scored, :assists, :minute_of_event, :yellow_cards, :red_cards, :notes,
      :tournament_id, :tenant_id, :_destroy
    ]
  )
end

  def set_match
    @match = Match.find(params[:id])
  end

  def set_season_team
    @season_team = SeasonTeam.find(params[:season_team_id])
  end
end