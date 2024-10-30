class CalendarsController < ApplicationController
    def redirect
      client = Signet::OAuth2::Client.new(client_options)
      #puts "Redirecting to: #{client.authorization_uri.to_s}"
      redirect_to client.authorization_uri.to_s, allow_other_host: true
        
    end

    def callback
      @client = Signet::OAuth2::Client.new(client_options)
    
      authorization_code = params[:code]
    
      @client.code = authorization_code
    
      response = @client.fetch_access_token!
      session[:authorization] = response
    
      redirect_to calendars_url
    end

    def calendars
      client = Signet::OAuth2::Client.new(client_options)
  
      client.update!(session[:authorization])
  
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
  
      @calendar_list = service.list_calendar_lists
      rescue Google::Apis::AuthorizationError
        response = client.refresh!

        session[:authorization] = session[:authorization].merge(response)

      retry

    end
    
    def events
      client = Signet::OAuth2::Client.new(client_options)
      client.update!(session[:authorization])

      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
  
      @event_list = service.list_events(params[:calendar_id]) #error happens here, say primary in url
      rescue Google::Apis::AuthorizationError
        response = client.refresh!
  
        session[:authorization] = session[:authorization].merge(response)
  
      retry
      #rescue Google::Apis::ClientError => e
      #  puts "Error: #{e.message}"
      #  puts "Calendar ID: #{params[:calendar_id]}"
        # Log the error message or handle it accordingly
    end
    def icalendar
      require 'icalendar'
      require 'open-uri'
      puts "Before opening URI"
      @calendars = nil
      @currTime = Time.new
      URI.open("https://calendar.google.com/calendar/ical/c_cbc58022ad21f89e06e114a10386754bc7803170afc55fb497499fc681d683ab%40group.calendar.google.com/public/basic.ics") do |cal|
        #calendars = RiCal.parse(cal)
        @calendars = Icalendar.parse(cal)
      end
      @events = @calendars[0].events
      @event = Event.all
    end
    
    private
    
      def client_options
        {
          
          client_id: Rails.application.credentials.google_oauth[:client_id] ,
          client_secret: Rails.application.credentials.google_oauth[:client_secret],
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
          redirect_uri: "http://127.0.0.1:3000/auth/google_oauth2/callback"
        }
      end
end
