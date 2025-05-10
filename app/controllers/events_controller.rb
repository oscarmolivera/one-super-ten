class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    authorize :event, :index?
    @events = policy_scope(Event).includes(:school, :categories).order(start_time: :desc)
  end

  def show; end

  def new
    authorize :event, :index?
    @event = Event.new
  end

  def create
    authorize :event, :index?
    @event = Event.new(event_params.merge(tenant: ActsAsTenant.current_tenant))
    if @event.save
      redirect_to events_path, notice: "Event created"
    else
      render :new
    end
  end

  def edit; end

  def update
    authorize :event, :index?
    if @event.update(event_params)
      redirect_to events_path, notice: "Event updated"
    else
      render :edit
    end
  end

  def destroy
    authorize :event, :index?
    @event.destroy
    redirect_to events_path, notice: "Event deleted"
  end

  def calendar
    authorize :event, :index?
    @events = policy_scope(Event).select(:id, :title, :start_time, :end_time)
    @calendar_events = @events.map do |e|
      {
        id: e.id,
        title: e.title,
        start: e.start_time.iso8601,
        end: e.end_time.iso8601
      }
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
    authorize :event, :index?
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :start_time, :end_time, :location_name,
      :location_address, :external_organizer, :organizer_name,
      :school_id, :coach_id, :event_type, :status,
      :allow_reinforcements, :is_public, category_ids: []
    )
  end
end
