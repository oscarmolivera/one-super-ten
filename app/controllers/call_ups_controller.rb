class CallUpsController < ApplicationController
  protect_from_forgery except: :cleanup
  skip_after_action :verify_policy_scoped, only: :index

  def index
    redirect_to root_path, alert: "Not implemented"
  end


  def new
    authorize :call_up, :index?
    @match = Match.find(params[:match_id])
  
    # Find or create CallUp using your service (good idea!)
    if @match.call_up.present?
      @call_up = @match.call_up
    else
      result = CallUps::CreateService.new(match: @match).call
      @call_up = result.call_up
    end
  
    season_team = @match.team_of_interest
    @season_team_players = season_team.all_players_for_call_up
  end

  def create
    authorize :call_up, :index?
    @call_up = CallUp.new(call_up_params)
    @call_up.tenant = ActsAsTenant.current_tenant

    if @call_up.save
      redirect_to matches_path, notice: "CallUp was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize :call_up, :index?
    @call_up = CallUp.find(params[:id])
    @match = @call_up.match
    season_team = @match.team_of_interest
    @season_team_players = season_team.all_players_for_call_up
  
    render partial: "call_ups/shared/form", locals: { call_up: @call_up, match: @match }, layout: false
  end

  def update
    authorize :call_up, :index?
    @call_up = CallUp.find(params[:id])

    parsed_ids = parse_mixed_player_ids(params[:call_up][:player_ids])

    service = CallUps::UpdateService.new(
      call_up: @call_up,
      params: call_up_params
              .except(:player_ids)
              .merge(
                player_ids: parsed_ids[:player_ids],
                external_player_ids: parsed_ids[:external_player_ids],
                call_up_date_only: params[:call_up_date_only],
                call_up_time_only: params[:call_up_time_only]
              )
    ).call

    if service.destroyed?
      redirect_to match_path(@call_up.match), alert: "Convocatoria eliminada porque no se seleccionaron jugadores."
    elsif service.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to match_path(@call_up.match), notice: "Convocatoria actualizada." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cleanup
    @call_up = CallUp.find(params[:id])
    authorize :call_up, :index?

    if @call_up.call_up_players.none?
      @call_up.destroy
      head :no_content
    else
      head :ok
    end
  end

  private

  def call_up_params
    params.require(:call_up).permit(:match_id, :category_id, :name, :call_up_date, player_ids: [])
  end

  def parse_mixed_player_ids(raw_ids)
    player_ids = []
    external_player_ids = []

    Array(raw_ids).reject(&:blank?).each do |value|
      type, id = value.to_s.split("-", 2)
      next unless id.present?

      case type
      when "player"
        player_ids << id.to_i
      when "external"
        external_player_ids << id.to_i
      end
    end

    {
      player_ids: player_ids,
      external_player_ids: external_player_ids
    }
  end
end