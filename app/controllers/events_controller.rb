class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :require_login, only: %i[new show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # Ensure user is logged in
  def require_login
    unless session[:authenticated]
      redirect_to login2_path, alert: "You must be logged in to access this page."
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if invalid_event_times?(@event)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: 'Event end time must be after the start time' }, status: :unprocessable_entity }
      elsif @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if invalid_event_times?(@event)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { error: 'Event end time must be after the start time' }, status: :unprocessable_entity }
      elsif @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Ensure event times are valid
  def invalid_event_times?(event)
    if event.event_end.nil? || event.event_datetime.nil?
      flash.now[:alert] = 'Event start and end times must be provided.'
      true
    elsif event.event_end < event.event_datetime
      flash.now[:alert] = 'Event end time must be after the start time.'
      true
    else
      false
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_url, alert: "Event not found."
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:event_link, :event_name, :event_datetime, :event_end, :event_points, :event_description)
  end
end
