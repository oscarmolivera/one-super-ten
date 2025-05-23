class PlayersController < ApplicationController
  before_action :authenticate_user!, except: [:public_show]
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_school, only: [:new, :edit, :update]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

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

    permitted = player_params
    new_carousel_images = permitted[:carousel_images]
    permitted_without_images = permitted.except(:carousel_images)

    if @player.update(permitted_without_images)
      assign_school(@player)
      @player.add_carousel_images(new_carousel_images) if new_carousel_images.present?
      redirect_to safe_redirect_path, notice: 'Player updated successfully.'
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

  def public_show
    @player = Player.find_by!(handle: params[:handle])

    raise ActiveRecord::RecordNotFound unless @player.public_profile?

    authorize @player, :public_show?

    @player_profile = @player.player_profile
    category = @player.categories.first
    @teammates = category.players
    render 'player_profiles/shared/_show'
  end

  def teammates
    authorize :player, :index?
    @player = Player.find(params[:id])

    category = @player.categories.first

    @teammates = category.players
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
    return unless player_school_valid?(player)

    player.player_schools.destroy_all

    school_ids = Array(params.dig(:player, :school_ids) || params[:school_id]).reject(&:blank?)
    school_ids.each do |school_id|
      player.player_schools.create(school_id: school_id)
    end
  end

  def player_school_valid?(player)
    school_ids = Array(params.dig(:player, :school_ids) || params[:school_id]).reject(&:blank?)

    Rails.logger.warn "⚠️ school_ids param - #{school_ids.inspect}"

    if school_ids.empty?
      Rails.logger.warn "⚠️ Player #{player.id} - #{player.full_name.presence || 'Unnamed'} received blank school_ids array!"
      return false
    end

    true
  end

  def player_params
    params.require(:player).permit(
      :email, :tenant_id, :first_name, :last_name, :full_name, :date_of_birth,
      :gender, :nationality, :document_number, :profile_picture, :dominant_side,
      :position, :address, :is_active, :bio, :notes, :user_id, :hero_image,
      :public_profile, :handle, school_ids: [], documents: [], carousel_images: [], 
      player_profile_attributes: [
        :id,
        :nickname,
        :jersey_number,
        :internal_notes,
        :status,
        :disciplinary_flag,
        :skill_rating,
        :social_links_facebook,
        :social_links_instagram,
        :social_links_tiktok
      ],
      guardians_attributes: [
        :id, :first_name, :last_name, :email, :phone, :gender, :relationship, :address, :notes, :_destroy
      ]
    )
  end
  
  def safe_redirect_path
    uri = URI.parse(params[:redirect_to]) rescue nil
    return players_path unless uri&.path&.starts_with?("/")
    uri.path
  end

  def render_404
    render 'errors/not_found', status: :not_found
  end
end
