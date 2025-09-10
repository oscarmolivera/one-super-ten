class StagesController < ApplicationController
  
  def check_closable
    @stage = Stage.find(params[:id])
    authorize @stage, :check_closable?
    render json: { closable: @stage.stage_closable? }
  end
end