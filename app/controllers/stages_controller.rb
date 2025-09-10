class StagesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:check_closable]
  
  def check_closable
    @stage = Stage.find(params[:id])
    authorize @stage, :check_closable? # Authorize the specific Stage instance
    render json: { closable: @stage.stage_closable? }
  end
end