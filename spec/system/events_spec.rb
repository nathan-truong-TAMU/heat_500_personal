# This file handles testing of events/new with User-Simulated input

require 'rails_helper'

RSpec.describe 'Creating an event', type: :system do
    # Handles authenticating to get admin access
    before do
        driven_by(:rack_test)

        # Authenticate the user through the UI
        visit login_manual_path # Assuming you have a login path
        fill_in 'Password', with: 'TxAMHeat#2k13'
        click_on 'Submit'
    end

    # Valid Tests
    scenario 'Creating an Event with Standard Inputs' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 10
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        event = Event.last
        visit event_path(event)
        expect(page).to have_content('Event Name: YouTuber Event')
        expect(page).to have_content('Event Description: Here, we will be YouTubing on the most YouTube ever.')
        expect(page).to have_content('Event Deadline: Saturday, 01 January 2000 at 12:00 AM')
        expect(page).to have_content('Event Start: Friday, 31 December 1999 at 11:59 PM')
        expect(page).to have_content('Event Points: 10')
    end

    scenario 'Creating an Event with Minimum Points' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 0
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        event = Event.last
        visit event_path(event)
        expect(page).to have_content('Event Name: YouTuber Event')
        expect(page).to have_content('Event Description: Here, we will be YouTubing on the most YouTube ever.')
        expect(page).to have_content('Event Deadline: Saturday, 01 January 2000 at 12:00 AM')
        expect(page).to have_content('Event Start: Friday, 31 December 1999 at 11:59 PM')
        expect(page).to have_content('Event Points: 0')
    end

    scenario 'Creating an Event with Maximum Points' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 999999999
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        event = Event.last
        visit event_path(event)
        expect(page).to have_content('Event Name: YouTuber Event')
        expect(page).to have_content('Event Description: Here, we will be YouTubing on the most YouTube ever.')
        expect(page).to have_content('Event Deadline: Saturday, 01 January 2000 at 12:00 AM')
        expect(page).to have_content('Event Start: Friday, 31 December 1999 at 11:59 PM')
        expect(page).to have_content('Event Points: 999999999')
    end


    # Invalid Inputs
    scenario 'Creating an Event with an Empty Link' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: ''
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 999999999
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Link can't be blank!")
    end

    scenario 'Creating an Event with an Invalid Link' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/john'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 999999999
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Link must be reachable!")
    end

    scenario 'Creating an Event with Missing Name' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: ''
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: 999999999
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Name can't be blank!")
    end

    scenario 'Creating an Event with End Date Before Start Date' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '1999-12-31T23:59'
        fill_in 'event[start_date]', with: '2000-01-01T00:00'
        fill_in 'event[points]', with: 10
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Start date can't be after the End date!")
    end

    scenario 'Creating an Event with Missing Points' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: ''
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Points can't be blank!")
    end

    scenario 'Creating an Event with Negative Points' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: '/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '2000-01-01T00:00'
        fill_in 'event[start_date]', with: '1999-12-31T23:59'
        fill_in 'event[points]', with: -1
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        expect(page).to have_content("Points can't be negative!")
    end
end