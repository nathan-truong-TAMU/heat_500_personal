require 'axlsx'

class EventsMembersController < ApplicationController
  before_action :set_event_member, only: %i[show edit update destroy]
  before_action :require_login, except: %i[register_attendance]

  # GET /events_members
  def index
    @events = Event.all
    @events_members = EventsMember.includes(:event, :member).all
    @members = Member.all # Add this line to set @members
  end

  # for exporting table data
  def export
    @events = Event.order(start_date: :desc)
    package = Axlsx::Package.new
    wb = package.workbook
    wb.add_worksheet(name: 'Event Attendance') do |sheet|
      sheet.add_row %w[Date Event Members]
      @events.each do |event|
        event_members = event.events_members
        members_list = event_members.any? ? event_members.map { |em| em.member.name }.join(', ') : 'No attendees yet'
        sheet.add_row [event.start_date.strftime('%B %d, %Y'), event.name, members_list]
      end
    end

    send_data package.to_stream.read, filename: 'event_attendance.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  # GET /events_members/1
  def show; end

  # GET /events_members/new
  def new
    @event_member = EventsMember.new
  end

  # GET /events_members/1/edit
  def edit; end

  # new code
  def remove_member_from_event
    event_id = params[:event_id]
    member_id = params[:member_id]

    # end the function here and send alert
    if event_id.present? && member_id.present?
      @event = Event.find(params[:event_id])
      @member = Member.find(params[:member_id])

      if @event && @member && @event.members.include?(@member)
        # Remove the member from the event
        @event.members.delete(@member)

        # Deduct one point from the member's member_points value
        @member.decrement!(:points, @event.points) # change this to a variable number.

        flash[:notice] = "Member removed from event successfully and points deducted!"
      else
        flash[:alert] = "Failed to remove member from event!"
      end
    else
      flash[:alert] = "Failed to remove member, either the event or member doesn't exist!"
    end

    redirect_to events_members_path
  end

  # POST /events_members
  def create
    @event_member = EventsMember.new(event_member_params)

    # Check if the member is already in the event
    if EventsMember.exists?(event_id: @event_member.event_id, member_id: @event_member.member_id)
      redirect_to events_members_path, alert: 'Member is already in the event!'
      return
    end

    respond_to do |format|
      if @event_member.save
        @member = Member.find(@event_member.member_id)
        @event = Event.find(@event_member.event_id)
        @member.increment!(:points, @event.points)

        format.html { redirect_to events_members_path, notice: 'Member added to event successfully!' }
        format.json { render :show, status: :created, location: @event_member }
      else
        format.html { redirect_to events_members_path, alert: "Failed to add member to event! #{@event_member.errors.full_messages.join(', ')}" }
        format.json { render json: @event_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events_members/1
  def update
    respond_to do |format|
      if @event_member.update(event_member_params)
        format.html { redirect_to @event_member, notice: 'Event member was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events_members/1
  def destroy
    @event_member.destroy
    respond_to do |format|
      format.html { redirect_to events_members_url, notice: 'Event member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def register_attendance
    unless user_signed_in?
      # Set a custom return path to return here after login
      session[:return_to] = request.fullpath
      redirect_to login_path and return
    end

    event = Event.find(params[:id])
    timestamp = params[:timestamp].to_i
    member = Member.find_by(email: current_user.email) # Assume the person scanning is the logged-in user

    if member.nil?
      flash[:alert] = "Member record not found for the current user."
      redirect_to events_path and return
    end
    # Check if the QR code was scanned within the last 10 mins
    if Time.now.to_i - timestamp <= 600
      # Register the member for the event if not already registered
      if EventsMember.exists?(event:, member:)
        flash[:alert] = "You are already registered for this event."
      else
        event.events_members.create(member:)
        member.increment!(:points, event.points)
        flash[:notice] = "#{member.name} successfully checked in for #{event.name}!"
      end
    else
      flash[:alert] = "QR code expired. Please try again."
    end

    redirect_to event_path(event)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event_member
    @event_member = EventsMember.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_member_params
    params.require(:events_member).permit(:event_id, :member_id)
  end
end
