class TrainingAttendancesController < ApplicationController
  before_action :set_training_session
  before_action :set_attendance, only: [:edit, :update]
  before_action :allow_user, only: %i[index edit new create update destroy]

  def index
    @attendances = policy_scope(@training_session.training_attendances.includes(:player))
  end

  def new
    @attendance = @training_session.training_attendances.new
  end

  def create
    @attendance = @training_session.training_attendances.new(attendance_params)

    if @attendance.save
      redirect_to training_session_training_attendances_path(@training_session), notice: "Asistencia registrada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @attendance.update(attendance_params)
      redirect_to training_session_training_attendances_path(@training_session), notice: "Asistencia actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def allow_user
    authorize :training_session, :index?
  end

  def set_training_session
    @training_session = TrainingSession.find(params[:training_session_id])
  end

  def set_attendance
    @attendance = @training_session.training_attendances.find(params[:id])
  end

  def attendance_params
    params.require(:training_attendance).permit(:player_id, :status, :notes)
  end
end