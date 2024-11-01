class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]
  before_action :require_login, except: [:check_member_attendance, :leaderboard, :update] #update also added because members should be able to access it to change profile

  def check_member_attendance
    if current_user.present?
      puts current_user.email
      @member = Member.find_by(email: current_user.email)
      @member_events = EventsMember.includes(:event, :member).where(member: @member.id)
      @join_events = @member.events.all #calls the join table to get all the events for the member

      @attended = 
        (if @member.present? && ( @member.events.any?)
          true
        else
          false
        end)
    else
      @attended = false
    end
  end

  # GET /leaderboard
  def leaderboard
    #the controller method/action for the leaderboard page. Should really only be retrieval of information
    @filter = params[:filter]
    
    #get all members and officers from the club
    get_members
    
    @members = @members.order(points: "desc")

    @curr = 1

    @join_google_users = User.select("users.*, members.*").joins("INNER JOIN members ON members.email = users.email")
    @join_google_users = @join_google_users.order(points: "desc")

    if(@filter)
      @join_google_users = @join_google_users.where("dues_paid = true")
    end

    puts @join_google_users

  end

  def set_member
    @member = current_user.member
  end

  # GET /members or /members.json
  def index
    get_members

    #need to check the params to filter and sort as indicated
    filter = params[:filter]
    sort = params[:sort]
    order = params[:order]

    #doing the sorting if needed
    member_index_sort(sort, order)

    #doing the filter if needed
    member_index_filter(filter)

  end

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    #making sure the points is at zero, since it's disabled on the html form it won't take the value thats there
    @member.points = 0 

    #validation to make sure there aren't repeat emails
    if Member.find_by(email: @member.email)
      respond_to do |format|
        @member.email = nil
        flash[:alert] = "You have errors with duplicate emails!"
        format.html { render :new, status: :unprocessable_entity }
      end
      
      #end the function to not have to continue
      return 
    end

    respond_to do |format|
      if @member.save
        format.html { redirect_to member_url(@member), notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html do
          # Add the following line to see the validation errors in the browser console
          puts @member.errors.inspect

          render :new, status: :unprocessable_entity
        end
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    #checking where the form was sent from
    source = params[:source] ? params[:source] : nil

    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to (!source ? member_url(@member) : "/check_member_attendance"), notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    #add check to not delete yourself
    if @member.email != current_user.email

      #remove the member from other tables
      destroy_member_manual

      #actually destroy the member
      @member.destroy

      respond_to do |format|
        format.html { redirect_to members_url, notice: "Member was successfully destroyed." }
        format.json { head :no_content }
      end

    else
      #Alert the user that they can't remove themselves
      respond_to do |format|
        format.html { redirect_to members_url, alert: "Member is current user, can't delete." }
        format.json { head :no_content }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Filter out to only members and officers
    def get_members
      @members = Member.where.not(position: "admin")
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :points, :position, :dues_paid, :email, :source)
    end

    def destroy_member_manual
      # member_id = @member.id
      
      #remove from event_members table
      EventsMember.where(member_id: @member.id).delete_all

      #remove from announcements table
      Announcement.where(member_id: @member.id).delete_all
    end

    def member_index_sort(sort, order)
      if sort.present?
        if sort == "name" #Sort by name
          if order == "asc"
            @members = @members.order(name: "asc")
          else
            @members = @members.order(name: "desc")
          end
        elsif sort == "email" #Sort by email
          if order == "asc"
            @members = @members.order(email: "asc")
          else
            @members = @members.order(email: "desc")
          end
        elsif sort == "points" #Sort by points
          if order == "asc"
            @members = @members.order(points: "asc")
          else
            @members = @members.order(points: "desc")
          end
        elsif sort == "position" #Sort By position
          if order == "asc"
            @members = @members.order(position: "asc")
          else
            @members = @members.order(position: "desc")
          end
        else
          # No sort then
          # @members = @members.order(email: "desc")
        end
      end
    end

    def member_index_filter(filter)
      if filter.present?
        if filter == "dues" #filter by dues
          @members = @members.where("dues_paid = true")

        elsif filter == "members" #filter by position to get members only
          @members = @members.where(position: "Member")

        elsif filter == "officers" #filter by position to get members only
          @members = @members.where(position: "Officer")

        else
          # No sort then
          # @members = @members.order(email: "desc")
        end
      end
    end
end
