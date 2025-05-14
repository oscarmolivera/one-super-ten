class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :edit, :update]
  before_action :select_category, only: [:edit, :update]
  

  def index
    authorize :player, :index?
    @players = policy_scope(Player).order(updated_at: :desc)
  end

  def show
    authorize :player, :index?
    @player = Player.includes(:exonerations).find(params[:id])
  end

  def new
    authorize :player, :index?
    @player = Player.new
  end

  def create
    authorize :player, :index?
    @player = Player.new(player_params)
    if @player.save
      assign_school(@player)
      redirect_to players_path, notice: 'Player created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize :player, :index?
  end

  def update
    authorize :player, :index?
    if @player.update(player_params)
      assign_school(@player)
      redirect_to players_path, notice: 'Player updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

def destroy
  authorize :player, :destroy?
  if @player.destroy
    respond_to do |format|
      format.html { redirect_to players_path, notice: "Player deleted." }
      format.turbo_stream
    end
  else
    respond_to do |format|
      format.html { redirect_to players_path, alert: "Failed to delete player: #{@player.errors.full_messages.join(', ')}" }
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("messages", partial: "shared/flash", locals: { alert: "Failed to delete player: #{@player.errors.full_messages.join(', ')}" })
      end
    end
  end
end

  def assign_category
    authorize :player, :index?

    binding.pry
    @player = Player.find(params[:id])
    category = Category.find(params[:category_id])

    if @player.categories << category
      redirect_to players_path, notice: "Categoría asignada correctamente."
    else
      redirect_to select_category_player_path(@player), alert: "No se pudo asignar la categoría."
    end
  end

  def documents
    authorize :player, :index?

    @player = Player.find(params[:id])
  
    if params[:document].present?
      @player.documents.attach(params[:document].values)
      head :ok
    else
      render json: { error: "No document received" }, status: :unprocessable_entity
    end
  end

  def erase_document
    authorize :player, :index?
    @player = Player.find(params[:id])
    blob = ActiveStorage::Blob.find(params[:blob_id])
  
    attachment = @player.documents.find { |doc| doc.blob_id == blob.id }
    if attachment
      attachment.purge
      respond_to do |format|
        format.html { redirect_to edit_player_path(@player), notice: "Documento eliminado." }
        format.turbo_stream
      end
    else
      redirect_to edit_player_path(@player), alert: "No se encontró el documento."
    end
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def set_school
    @schools = ActsAsTenant.current_tenant.schools
  end

  def assign_school(player)
    school_id = params[:school_id]
    return if school_id.blank?

    player.player_schools.destroy_all

    player.player_schools.create(school_id: school_id)
  end

  def player_params
    params.require(:player).permit(
      :email, :tenant_id, :first_name, :last_name, :full_name, :date_of_birth, 
      :gender, :nationality, :document_number, :profile_picture, :dominant_side, 
      :position, :address, :is_active, :bio, :notes, :user_id, documents: []
    )
  end

  def select_category
    @player = Player.find(params[:id])
    @school = @player.schools.first
    @categories = @school.categories.order(id: :asc)
  end
end
