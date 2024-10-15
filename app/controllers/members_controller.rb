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
    

    @members = Member.all
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
    @members = Member.all
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
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

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
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :points, :position, :dues_paid, :email, :source)
      # params.permit(:source)
    end
end
