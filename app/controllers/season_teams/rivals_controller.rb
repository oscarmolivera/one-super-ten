class SeasonTeams::RivalsController < ApplicationController
  before_action :set_season_team, except: %i[index create]
  before_action :authorize_rivals
  before_action :set_rival, only: %i[edit update destroy]

  def index
    @rivals = @season_team.rivals
    @rival  = Rival.new
  end
  
  def create
    @rival =
    if params[:existing_rival_id].present?
      @rival = Rival.find(params[:existing_rival_id])
    else
      Rival.new(rival_params.merge(tenant: ActsAsTenant.current_tenant))
    end
    
    @season_team = SeasonTeam.find(params[:season_team_id])
    if @rival.save
      @season_team.rivals << @rival unless @season_team.rivals.exists?(@rival.id)
  
      respond_to do |format|
        format.turbo_stream do
          render template: "season_teams/rivals/create"
        end
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
    if @rival.update(rival_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            # flash
            turbo_stream.replace(
              "rival_flash",
              partial: "shared/flash_stream",
              locals: { message: "Rival actualizado", kind: :success }
            ),
  
            # replace just the edited card
            turbo_stream.replace(
              view_context.dom_id(@rival),
              partial: "season_teams/rivals/rival",
              locals:  { rival: @rival }
            ),
  
            # close the modal + remove backdrop
            turbo_stream.append(
              "turbo_stream_events",
              partial: "shared/close_modal",
              locals: {
                modal_id:  "editRivalModalContent-#{@rival.id}",
                frame_id:  "editRivalModal-#{@rival.id}"
              }
            ),
  
            # (optional) drop the frame node
            turbo_stream.remove("editRivalModal-#{@rival.id}")
          ]
        end
  
        format.html { redirect_to tournament_data_season_team_path(@season_team),
                      notice: "Rival actualizado." }
      end
    else
      render turbo_stream: turbo_stream.replace(
        "editRivalModal-#{@rival.id}",
        partial: "season_teams/rivals/edit_modal_frame",
        locals:  { rival: @rival, season_team: @season_team }
      ), status: :unprocessable_entity
    end
  end

  def destroy
    @season_team.rivals.destroy(@rival)
    redirect_to tournament_data_season_team_path(@season_team), notice: "Rival eliminado."
  end

  private

  def set_season_team
    @season_team = SeasonTeam.find(params[:season_team_id] || params[:id])
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