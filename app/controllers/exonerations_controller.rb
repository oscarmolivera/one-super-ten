class ExonerationsController < ApplicationController
  before_action :set_exoneration, only: [:edit, :update, :destroy]
  before_action :authorize_exoneration

  def new
    @player = Player.find(params[:player_id])
    @exoneration = @player.exonerations.new
  end

  def create
    @player = Player.find(params[:exoneration][:player_id])
    @exoneration = @player.exonerations.new(exoneration_params)
    @exoneration.tenant = current_tenant

    if @exoneration.save
      redirect_to player_path(@player), notice: "Jugador exonerado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @exoneration.update(exoneration_params)
      redirect_to player_path(@exoneration.player), notice: "Exoneración actualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exoneration.destroy
    redirect_to player_path(@exoneration.player), notice: "Exoneración eliminada."
  end

  private

  def set_exoneration
    @exoneration = Exoneration.find(params[:id])
  end

  def authorize_exoneration
    authorize :exoneration, :index?
  end

  def exoneration_params
    params.require(:exoneration).permit(:player_id, :start_date, :end_date, :reason)
  end
end