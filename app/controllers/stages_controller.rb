class StagesController < ApplicationController
  def check_closable
    authorize :stage, :index?

    @stage = Stage.find(params[:id]) # Assuming current_stage is a Stage
    render json: { closable: @stage.stage_closable? }
  end
end