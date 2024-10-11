class ApplicationController < ActionController::Base
    # Checks if a user is an officer or admin
    def is_officer_or_admin?
        (session[:authenticated] == 'Officer' || session[:authenticated] == "Admin")
    end
    helper_method :is_officer_or_admin?

    # Checks if a user's current view is either an officer or admin view
    def is_officer_or_admin_view?
        (session[:view_mode] == 'Officer' || session[:view_mode] == "Admin")
    end
    helper_method :is_officer_or_admin_view?

    # Redirects user to the admin/officer password page if they aren't an admin/officer
    def require_login
        redirect_to login2_path unless is_officer_or_admin?
    end
end
