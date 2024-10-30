module ApplicationHelper
    def valid_url?(url)
        url =~ /\A(http|https):\/\/[^\s\/$.?#].[^\s]*\z/
    end

    def is_officer_or_admin?(session)
        session[:authenticated] == 'Admin' || session[:authenticated] == 'Officer'
    end
    
    def is_officer_or_admin_view?(session)
        session[:view_mode] == 'Admin' || session[:view_mode] == 'Officer'
    end

    # Checks if a user is a guest or in guest view
    def is_guest_or_guest_view?(session)
        session[:authenticated] == 'Guest' || session[:view_mode] == 'Guest'
    end
end
