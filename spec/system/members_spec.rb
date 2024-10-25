# This file handles testing of members/new with User-Simulated input

require 'rails_helper'

RSpec.describe 'Creating a member', type: :system do
    # Handles authenticating to get admin access
    before do
        driven_by(:rack_test)

        # Authenticate the user through the UI
        visit login_manual_path # Assuming you have a login path
        fill_in 'Password', with: 'TxAMHeat#2k13'
        click_on 'Submit'
    end


    # Valid Tests
    scenario 'Creating a Member with Standard Inputs' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 100
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 100')
        expect(page).to have_content('Dues Paid: Yes')
        expect(page).to have_content('Position: Officer')
    end

    scenario 'Creating a Member with Minimum Points' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 0
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 0')
        expect(page).to have_content('Dues Paid: Yes')
        expect(page).to have_content('Position: Officer')
    end

    scenario 'Creating a Member with Maximum Points' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 999999999
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 999999999')
        expect(page).to have_content('Dues Paid: Yes')
        expect(page).to have_content('Position: Officer')
    end

    scenario 'Creating a Member with No Dues Paid' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 999999999
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 999999999')
        expect(page).to have_content('Dues Paid: No')
        expect(page).to have_content('Position: Officer')
    end

    scenario 'Creating a Member with Member Role' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 999999999
        select 'Member', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 999999999')
        expect(page).to have_content('Dues Paid: No')
        expect(page).to have_content('Position: Member')
    end

    scenario 'Creating a Member with Officer Role' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 999999999
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 999999999')
        expect(page).to have_content('Dues Paid: No')
        expect(page).to have_content('Position: Officer')
    end

    scenario 'Creating a Member with Admin Role' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 999999999
        select 'Admin', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.last
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 999999999')
        expect(page).to have_content('Dues Paid: No')
        expect(page).to have_content('Position: Admin')
    end


    # Invalid Tests
    scenario "Creating a Member with Missing Name" do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: ''
        fill_in 'member[points]', with: 100
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        expect(page).to have_content("Name can't be blank!")
    end


    scenario "Creating a Member with Missing Points" do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: ''
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        expect(page).to have_content("Points can't be blank!")
    end


    scenario "Creating a Member with Negative Points" do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: -1
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        expect(page).to have_content("Points can't be negative!")
    end
end