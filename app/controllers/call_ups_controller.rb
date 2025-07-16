class CallUpsController < ApplicationController
  protect_from_forgery except: :cleanup

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

    # Recombine date + time
    date = params[:call_up_date_only]
    time = params[:call_up_time_only]
    if date.present? && time.present?
      combined_datetime = Time.zone.parse("#{date} #{time}")
      @call_up.call_up_date = combined_datetime
    end

    selected_player_ids = params[:call_up][:player_ids].reject(&:blank?).map(&:to_i)
    current_player_ids = @call_up.call_up_players.pluck(:player_id)

    ids_to_add = selected_player_ids - current_player_ids
    ids_to_remove = current_player_ids - selected_player_ids

    if selected_player_ids.empty?
      @call_up.destroy
      redirect_to match_path(@call_up.match), alert: "Convocatoria eliminada porque no se seleccionaron jugadores."
      return
    end

    ActiveRecord::Base.transaction do
      @call_up.call_up_players.where(player_id: ids_to_remove).destroy_all

      if ids_to_add.any?
        rows = ids_to_add.map do |pid|
          { call_up_id: @call_up.id, player_id: pid, attendance: false, created_at: Time.zone.now, updated_at: Time.zone.now }
        end
        CallUpPlayer.insert_all(rows)
      end

      @call_up.update!(call_up_params.except(:player_ids, :call_up_date))
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to match_path(@call_up.match), notice: "Convocatoria actualizada." }
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
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
    params.require(:call_up).permit(
      :match_id,
      :category_id,
      :name,
      :call_up_date,
      player_ids: []
    )
  end
end