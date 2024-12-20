class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(auth)

    if user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in(user, event: :authentication)

      # Checks the email of the google account's permissions in the member table
      member = Member.find_by(email: user.email)

      # If the user is logging into the website for the first time, automatically add their information to members table
      member ||= Member.create(
        name: user.full_name,
        email: user.email,
        position: 'Member',
        points: 0,
        dues_paid: false
      )

      # Handles setting session variables
      if member&.position == 'Admin'
        session[:authenticated] = 'Admin'
        session[:view_mode] = 'Admin'
      elsif member&.position == 'Officer'
        session[:authenticated] = 'Officer'
        session[:view_mode] = 'Officer'
      else
        session[:authenticated] = 'Member'
        session[:view_mode] = 'Member'
      end

      redirect_to session.delete(:return_to) || after_sign_in_path_for(user) and return
    else
      flash[:alert] =
        t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
