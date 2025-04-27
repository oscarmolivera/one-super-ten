class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:index, :susudio, :kamaly]
  skip_before_action :authenticate_user!, only: [:index, :susudio, :kamaly]

  def index; end

  def susudio
    authorize :home, :susudio?

    respond_to do |format|
      format.html
      format.json { render json: { message: 'ok' } }
    end
  end

  def kamaly
    authorize :home, :susudio?

    respond_to do |format|
      format.html
      format.json { render json: { message: 'ok' } }
    end
  end
end
