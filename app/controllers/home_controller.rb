class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:index, :susudio, :kamala]
  skip_before_action :authenticate_user!, only: [:index, :susudio, :kamala]

  def index; end

  def susudio
    authorize :home, :susudio?

    respond_to do |format|
      format.html
      format.json { render json: { message: 'ok' } }
    end
  end

  def kamala
    authorize :home, :kamala?

    respond_to do |format|
      format.html
      format.json { render json: { message: 'ok' } }
    end
  end
end
