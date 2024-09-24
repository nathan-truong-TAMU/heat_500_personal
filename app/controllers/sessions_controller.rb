class SessionsController < ApplicationController
  def new

    session[:previous_url] = request.referrer unless request.referrer == login_url

    @meetings = Meeting.all
    @events = Event.all
    @links = Link.all
  end

  def toggle_view_mode
    # Toggle between 'admin' and 'guest' view modes
    session[:view_mode] = session[:view_mode] == 'admin' ? 'guest' : 'admin'
    # Redirect back to the previous page (or home if not available)
    redirect_to request.referrer || root_path, notice: "View mode switched."
  end

  def newevent
    @events = Event.all
  end

  def newlink
    @links = Link.all
  end

  def new2
    @meetings = Meeting.all
    @events = Event.all
    @links = Link.all
  end

  def destroy
    reset_session  # Clears the entire session
    redirect_to login2_path, notice: 'You have been logged out.'
  end

  def create
    @meetings = Meeting.all
    @events = Event.all
    @links = Link.all
    if params[:password] == 'TxAMHeat#2k13'
      session[:authenticated] = true
      session[:view_mode] = 'admin'
      redirect_to session[:previous_url] || root_path, notice: 'Successfully authenticated.'
    else
      flash.now[:alert] = 'Invalid password'
      render :new
    end
  end
end
