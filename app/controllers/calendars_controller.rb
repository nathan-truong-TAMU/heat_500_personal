class CalendarsController < ApplicationController
    def redirect
        client = Signet::OAuth2::Client.new(client_options)
    
        redirect_to client.authorization_uri.to_s
        
      end
    
      private
    
      def client_options
        {
          client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'] ,
          client_secret: ENV['GOOGLE_OAUTH_CLIENT_SECRET'],
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
          redirect_uri: callback_url
        }
      end
end
