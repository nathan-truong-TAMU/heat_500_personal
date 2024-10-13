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
        fill_in 'event[link]', with: 'https://www.youtube.com/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '1999-12-31T23:59'
        fill_in 'event[start_date]', with: '2000-01-01T00:00'
        fill_in 'event[points]', with: 10
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        event = Event.last
        visit event_path(event)
        expect(page).to have_content('Event Link: https://www.youtube.com/')
        expect(page).to have_content('Event Name: YouTuber Event')
        expect(page).to have_content('Event Description: Here, we will be YouTubing on the most YouTube ever.')
        expect(page).to have_content('Event Deadline: Friday, 31 December 1999 at 11:59 PM')
        expect(page).to have_content('Event Start: Saturday, 01 January 2000 at 12:00 AM')
    end

    scenario 'Creating an Event with Standard Inputs' do
        # Navigates and fills out the new Event form
        visit new_event_path
        fill_in 'event[link]', with: 'https://www.youtube.com/'
        fill_in 'event[name]', with: 'YouTuber Event'
        fill_in 'event[description]', with: 'Here, we will be YouTubing on the most YouTube ever.'
        fill_in 'event[end_date]', with: '1999-12-31T23:59'
        fill_in 'event[start_date]', with: '2000-01-01T00:00'
        fill_in 'event[points]', with: 10
        click_on 'Create Event'

        # Checks in the show page that the event is correctly displayed
        event = Event.last
        visit event_path(event)
        expect(page).to have_content('Event Link: https://www.youtube.com/')
        expect(page).to have_content('Event Name: YouTuber Event')
        expect(page).to have_content('Event Description: Here, we will be YouTubing on the most YouTube ever.')
        expect(page).to have_content('Event Deadline: Friday, 31 December 1999 at 11:59 PM')
        expect(page).to have_content('Event Start: Saturday, 01 January 2000 at 12:00 AM')
    end
end