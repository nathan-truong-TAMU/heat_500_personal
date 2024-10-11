class SessionsController < ApplicationController
  def new

    session[:previous_url] = request.referrer unless request.referrer == login_url
    @events = Event.all
    @links = Link.all
  end

  # Toggles between Admin/Guest or Officer/Guest depending on roles
  def toggle_view_mode
    if session[:authenticated] == 'Admin'
      session[:view_mode] = session[:view_mode] == 'Admin' ? 'Guest' : 'Admin'
    elsif session[:authenticated] == 'Officer'
      session[:view_mode] = session[:view_mode] == 'Officer' ? 'Guest' : 'Officer'
    end

    redirect_to request.referrer || root_path, notice: "View mode switched."
  end

  def newevent
    @events = Event.all
  end

  def newlink
    @links = Link.all
  end

  def new2
    @events = Event.all
    @links = Link.all
  end

  def destroy
    reset_session  # Clears the entire session
    redirect_to login2_path, notice: 'You have been logged out.'
  end

  def create
    @events = Event.all
    @links = Link.all
    member = Member.find_by(email: params[:email])
    if params[:password] == 'TxAMHeat#2k13'|| member&.position == 'Admin'
      session[:authenticated] = 'Admin'
      session[:view_mode] = 'Admin'
      redirect_to session[:previous_url] || root_path, notice: 'Successfully authenticated.'
    else
      flash.now[:alert] = 'Invalid password'
      render :new
    end
  end
end
