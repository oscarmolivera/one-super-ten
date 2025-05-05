class TrainingSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training_session, only: %i[show edit update destroy]
  before_action :allow_user, only: %i[index edit new create update destroy]

def index
  @category = Category.find(params[:category_id])
  @training_sessions = policy_scope(TrainingSession).where(category_id: @category.id).order(scheduled_at: :desc)
end

  def show; end

  def new
    @training_session = TrainingSession.new
  end

  def edit; end

  def create
    @training_session = TrainingSession.new(training_session_params)
    if @training_session.save
      redirect_to training_sessions_path, notice: "Training created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @training_session.update(training_session_params)
      redirect_to training_sessions_path, notice: "Training updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @training_session.destroy
    redirect_to training_sessions_path, notice: "Training deleted."
  end

  private

  def allow_user
    authorize :training_session, :index?
  end

  def policy_scope_with_category(scope, category_id: nil)
    TrainingSessionPolicy::Scope.new(current_user, scope, category_id: category_id).resolve
  end

  def set_training_session
    @training_session = TrainingSession.find(params[:id])
  end

  def training_session_params
    params.require(:training_session).permit(
      :category_id, :coach_id, :site_id, :scheduled_at, :duration_minutes,
      :objectives, :activities, :notes
    )
  end
end