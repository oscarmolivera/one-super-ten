class SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_school, only: [:show, :edit, :update, :destroy]

  def index
    authorize :school, :index?
    @schools = policy_scope(School)
  end

  def show
    authorize :school, :index?
  end

  def new
    authorize :school, :index?
    @school = School.new
  end

  def create
    authorize :school, :index?
    @school = School.new(school_params)
    if @school.save
      redirect_to schools_path, notice: "School created successfully."
    else
      render :new
    end
  end

  def edit
    authorize :school, :index?
  end

  def update
    if @school.update(school_params)
      redirect_to schools_path, notice: "School updated successfully."
    else
      render :edit
    end
  end

  def destroy
    authorize :school, :destroy?
    if @school.destroy
      respond_to do |format|
        format.html { redirect_to schools_path, notice: "School deleted." }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to schools_path, alert: "Failed to delete school: #{@school.errors.full_messages.join(', ')}" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "shared/flash", locals: { alert: "Failed to delete school: #{@school.errors.full_messages.join(', ')}" })
        end
      end
    end
  end

  def categories
    authorize :school, :show?
    @categories = @school.categories
    respond_to do |format|
      format.json { render json: @categories.map { |c| { id: c.id, name: c.name } } }
      format.turbo_stream
    end
  end

  private

  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :description)
  end
end