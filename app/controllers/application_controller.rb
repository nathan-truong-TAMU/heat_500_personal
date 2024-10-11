class ApplicationController < ActionController::Base
    def require_login
        redirect_to login2_path unless (session[:authenticated] == 'Officer' || session[:authenticated] == "Admin")
      end
end
