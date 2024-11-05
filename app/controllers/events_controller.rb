class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy qr_code]
  before_action :require_login, only: %i[new show edit update destroy destroy_all]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # DELETE /events/destroy_all
  def destroy_all
    if session[:authenticated]
      # Loops through and destroys each event and it's relationships
      Event.all.each do |event|
        destroy_event_relationships(event)
        event.destroy
      end
      
      redirect_to events_url, notice: "All events have been successfully deleted."
    else
      redirect_to events_url, alert: "You do not have permission to delete all events."
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
      if @event.save
        # Adds event's URL to the link attribute
        @event.update(link: event_url(@event))

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
      if @event.update(event_params)
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
    destroy_event_relationships(@event)
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def qr_code
    # Generate QR code data with event_id and timestamp
    qr_data = "#{request.base_url}/events/#{@event.id}/register_attendance?timestamp=#{Time.now.to_i}"
    
    # Generate the QR code
    qr_code = RQRCode::QRCode.new(qr_data)
    @qr_svg = qr_code.as_svg(module_size: 4)
    
    render 'qr_code'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound 
    redirect_to events_url, alert: "Event not found."
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:link, :name, :start_date, :end_date, :points, :description, :category, :location)
  end

  # Deletes relationships from the database
  def destroy_event_relationships(event)
    # Removes points of the event from each member that attended
    event.events_members.each do |event_member|
      member = Member.find(event_member.member_id)
      member.update(points: [member.points - event.points, 0].max)
    end

    # Destroys all of the joint tables between members and events
    event.events_members.destroy_all
  end
end


