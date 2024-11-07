class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: %i[show edit update destroy]
  before_action :require_member_login, only: %i[ index ]
  before_action :get_member, only: %i[new create update destroy]
  before_action :require_login, only: %i[show new create edit update destroy]

  # GET /announcements or /announcements.json
  def index
    @announcements = Announcement.all
    @announcements = @announcements.order(created_at: "desc")
  end

  # GET /announcements or /announcements.json
  def indexMembers
    # meant to be so that it needs only member login
    @announcements = if current_user.present?
                       Announcement.all
                     else
                       []
                     end
  end

  # GET /announcements/1 or /announcements/1.json
  def show
    # Join statements are not needed can just get member by doing, as long as there is a active record relationship
    member = @announcement.member
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit; end

  # POST /announcements or /announcements.json
  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.member_id = @member.id

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to announcement_url(@announcement), notice: "Announcements was successfully created." }
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcement_url(@announcement), notice: "Announcements was successfully updated." }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1 or /announcements/1.json
  def destroy
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to announcements_url, notice: "Announcements was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def get_member
    puts "Member method"
    if current_user.present?
      @member = Member.find_by(email: current_user.email)
    else
      redirect_to login_path
    end
  end

  # Only allow a list of trusted parameters through.
  def announcement_params
    params.require(:announcement).permit(:title, :description, :member_id, :start_date)
  end
end
