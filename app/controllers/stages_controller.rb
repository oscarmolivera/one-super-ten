class StagesController < ApplicationController
  
  def check_closable
    @stage = Stage.find(params[:id])
    authorize @stage, :check_closable? # Authorize the specific Stage instance
    render json: { closable: @stage.stage_closable? }
  end
end