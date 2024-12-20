class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy qr_code add_members add_members_post remove_members remove_members_delete]
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

  #GET method to /events/id/add_members
  def add_members
    @members = Member.left_outer_joins(:events_members).where(events_members: { event_id: nil })
    .where.not(id: EventsMember.select(:member_id).where(event_id: @event.id), name: "Admin")
  end

  #POST method from /events/id/add_members
  def add_members_post
    selected_members = params[:member_ids]

    unless selected_members.present?
      flash[:alert] = "No member has been selected!"

      respond_to do |format|
        @event.errors.add(:name, "Error")
        format.html { redirect_to add_members_event_path(@event) }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
      return
    end

    selected_members = selected_members[:ids]

    unless selected_members.present?
      puts "Need to select members (array of input not being read properly)"

      respond_to do |format|
        format.html { redirect_to add_members_event_path(@event), notice: "Not member selected" }
      end
      return
    end

    #this might throw an error if one of the ids doesn't exist
    #if that's the case then switch to Member.where(id: selected_members)
    #However if there is an error then it needs to be looked into cause all ids should exist in table
    members = Member.where(id: selected_members)

    members.each do |member|
      event_member = EventsMember.new(event_id: @event.id, member_id: member.id)
      
      unless event_member.save
        #if the save fails
        flash[:alert] =  "Unable to add member to the event - member joined table"
        redirect_to add_members_event_path(@event)

        return
      end
      member.increment!(:points, @event.points)
    end

    respond_to do |format|
      flash[:alert] = "Members added succesfully and points incremented!(Alert)"
      format.html { redirect_to add_members_event_path(@event), notice: "Members added" }
    end
  end

  #Get method to /events/id/remove_members
  def remove_members
    @members = @event.members
  end

  #DELETE method from /events/id/remove_members
  def remove_members_delete
    selected_members = params[:member_ids]

    unless selected_members.present?
      flash[:alert] = "No member has been selected!"

      respond_to do |format|
        format.html { redirect_to add_members_event_path(@event) }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
      return
    end

    selected_members = selected_members[:ids]

    unless selected_members.present?
      # puts "No member has been selected!(Array of input not working properly)"
      
      respond_to do |format|
        format.html { redirect_to add_members_event_path(@event), notice: "No member has been selected!(Array of input not working properly)" }
      end
      return
    end

    #this might throw an error if one of the ids doesn't exist
    #if that's the case then switch to Member.where(id: selected_members)
    #However if there is an error then it needs to be looked into cause all ids should exist in table
    members = Member.where(id: selected_members)

    members.each do |member|
      if @event.members.include?(member)
        # Remove the member from the event
        @event.members.delete(member)

        # Deduct one point from the member's member_points value
        member.decrement!(:points, @event.points) # change this to a variable number.

        # flash[:notice] = "Member removed from event successfully and points deducted!"
      else
        flash[:alert] = "Failed to remove member from event! Member not in the event."
      end
      
    end

    respond_to do |format|
      flash[:alert] = "Members Removed Succesfully and points deducted!(Alert)"
      format.html { redirect_to remove_members_event_path(@event), notice: "Members Removed Succesfully and points deducted!" }
    end
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
