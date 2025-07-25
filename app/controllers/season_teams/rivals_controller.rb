class SeasonTeams::RivalsController < ApplicationController
  include ActionView::RecordIdentifier # This module provides the `dom_id` helper method for Turbo Streams

  before_action :set_season_team, except: %i[create]
  before_action :authorize_rivals
  before_action :set_rival, only: %i[edit update destroy]
  skip_after_action :verify_policy_scoped, only: :index

  def create
    @season_team = SeasonTeam.find(params[:season_team_id])
  
    rival_attributes = params[:existing_rival_id].present? ? {} : rival_params
  
    service = Rivals::CreateService.new(
      season_team: @season_team,
      existing_rival_id: params[:existing_rival_id],
      rival_params: rival_attributes
    ).call
  
    @rival = service.data[:rival]
  
    if service.success?
      respond_to do |format|
        format.turbo_stream { render template: "season_teams/rivals/create" }
        format.html { redirect_back fallback_location: tournament_data_season_team_path(@season_team) }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    render turbo_stream: turbo_stream.replace(
      "editRivalModal-#{@rival.id}",
      partial: "season_teams/rivals/edit_modal_frame",
      locals: { rival: @rival, season_team: @season_team }
    )
  end

  def update
    service = Rivals::UpdateService.new(rival: @rival, params: rival_params).call
  
    if service.success?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("rival_flash", partial: "shared/flash_stream", locals: { message: "Rival actualizado", kind: :success }),
            turbo_stream.replace(view_context.dom_id(@rival), partial: "season_teams/rivals/rival", locals: { rival: @rival }),
            turbo_stream.append(
              "turbo_stream_events", 
              partial: "shared/close_modal", 
              locals: { modal_id: "editRivalModalContent-#{@rival.id}", 
              frame_id: "editRivalModal-#{@rival.id}" }
            ),
          ]
        end
        format.html { redirect_to tournament_data_season_team_path(@season_team), notice: "Rival actualizado." }
      end
    else
      render turbo_stream: turbo_stream.replace(
        "editRivalModal-#{@rival.id}",
        partial: "season_teams/rivals/edit_modal_frame",
        locals: { rival: @rival, season_team: @season_team }
      ), status: :unprocessable_entity
    end
  end

  def destroy
    @season_team.rivals.delete(@rival)
    respond_to do |format|
      format.turbo_stream do
        streams = [
          # flash message (re-uses the same partial you already have)
          turbo_stream.replace(
            "rival_flash",
            partial: "shared/flash_stream",
            locals: { message: "Rival eliminado", kind: :success }
          ),
          turbo_stream.remove(dom_id(@rival))
        ]

        render turbo_stream: streams
      end

      format.html { redirect_to tournament_data_season_team_path(@season_team), notice: "Rival eliminado." }
    end
  end

  private

  def set_season_team
    # When the request comes from the delete button we receive both ids.
    @season_team = SeasonTeam.find(params[:season_team_id] || params[:season_team]&.dig(:id))
      
  end

  def set_rival
    @rival = Rival.find(params[:id])
  end

  def rival_params
    params.require(:rival).permit(:name, :location, :team_logo, :tenant_id, :is_favorite)
  end

  def authorize_rivals
    authorize :rival, :index?
  end
end