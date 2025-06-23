class SeasonTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_season_team, only: %i[show edit update destroy tournament_data upload_regulations]
  before_action :authorize_season_team, except: %i[index new create public_actives]

  def index
    @season_teams = policy_scope(SeasonTeam).where(tenant: ActsAsTenant.current_tenant)
  end

  def show; end

  def new
    authorize :season_team, :new?

    @season_team = SeasonTeam.new
  end

  def create
    @season_team = SeasonTeam.new(season_team_params)
    @season_team.tenant = ActsAsTenant.current_tenant
    authorize @season_team

    if @season_team.save
      redirect_to @season_team, notice: 'Equipo de temporada creado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @season_team = SeasonTeam.find(params[:id])
  end

  def update
    if @season_team.update(season_team_params)
      redirect_to @season_team, notice: 'Equipo de temporada actualizado.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @season_team.destroy
    redirect_to season_teams_path, notice: 'Equipo de temporada eliminado.'
  end

  def tournament_data
    @rival = Rival.new
  
    begin
      @pagy, pagy_rivals = pagy(@season_team.rivals.with_attached_team_logo.order(:name), items: 2)
    rescue Pagy::OverflowError
      redirect_to season_team_tournament_data_path(@season_team, page: 1) and return
    end
  
    service = SeasonTeams::TournamentDataService.new(@season_team, @pagy, pagy_rivals)
    @tournament_data = service.data
  end

  def public_actives
    authorize :season_team, :index?
    @season_teams = SeasonTeam.all
  end

  def upload_regulations
    authorize @season_team, :upload_regulations?
    if params[:season_team][:regulation_files]
      @season_team.regulation_files.attach(params[:season_team][:regulation_files])
      flash[:notice] = "Documentos subidos correctamente."
    else
      flash[:alert] = "Debes seleccionar al menos un archivo."
    end
    redirect_to season_team_path(@season_team, anchor: 'regulations')
  end

  private

  def set_season_team
    @season_team = SeasonTeam.find(params[:id])
  end

  def authorize_season_team
    authorize @season_team
  end

  def season_team_params
    params.require(:season_team).permit(
      :name, :description, :category_id, :tournament_id, :active,
      :team_logo, :coach_id, :assistant_coach_id, :team_assistant_id
    )
  end

end
