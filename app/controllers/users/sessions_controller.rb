# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
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
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
