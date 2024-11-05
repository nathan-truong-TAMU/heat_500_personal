class CalendarsController < ApplicationController
    def icalendar
      require 'icalendar'
      require 'open-uri'
      puts "Before opening URI"
      @calendars = nil
      URI.open("https://calendar.google.com/calendar/ical/ieph4vul7arafa2deddtjpuu2s%40group.calendar.google.com/public/basic.ics") do |cal|
        #calendars = RiCal.parse(cal)
        @calendars = Icalendar.parse(cal)
      end
      @events = @calendars[0].events
      @eventdates = Array.new()
      @events.each do |event|
        name = event.summary
        dateTime = event.dtstart
        date = dateTime.strftime("%Y-%m-%d")
        @eventdates.append(date)
      end
      @event = Event.all
    end
end
