class ApplicationController < ActionController::Base
  # Checks if a user is an officer or admin
  def is_officer_or_admin?
    session[:authenticated] == 'Officer' || session[:authenticated] == "Admin"
  end

  # Checks if a user's current view is either an officer or admin view
  def is_officer_or_admin_view?
    session[:view_mode] == 'Officer' || session[:view_mode] == "Admin"
  end

  # Checks if a user is a member or in member view
  def is_member_or_member_view?
    session[:authenticated] == 'Member' || session[:view_mode] == 'Member'
  end

  # Redirects user to the admin/officer password page if they aren't an admin/officer
  def require_login
    if params[:from_event] == 'true'
      redirect_to login_path unless is_officer_or_admin?
    else
      redirect_to login_manual_path unless is_officer_or_admin?
    end
  end

  def require_member_login
    redirect_to login_path unless current_user.present?
  end
end
