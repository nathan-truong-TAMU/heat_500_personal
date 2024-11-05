# This file handles testing of links/new with User-Simulated input

require 'rails_helper'

RSpec.describe 'Creating a link', type: :system do
  # Handles authenticating to get admin access
  before do
    driven_by(:rack_test)

    # Authenticate the user through the UI
    visit login_manual_path # Assuming you have a login path
    fill_in 'Password', with: 'TxAMHeat#2k13'
    click_on 'Submit'
  end

  # Valid Tests
  scenario 'Creating a Link with Standard Inputs' do
    # Navigates and fills out the new Event form
    visit new_link_path
    fill_in 'link[title]', with: 'John'
    fill_in 'link[url]', with: 'https://www.youtube.com/'
    click_on 'Create Link'

    # Checks in the show page that the event is correctly displayed
    link = Link.last
    visit link_path(link)
    expect(page).to have_content('John')
  end
end
