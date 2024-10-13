require 'rails_helper'

RSpec.describe 'Creating a member', type: :system do
    before do
        driven_by(:rack_test)

        # Authenticate the user through the UI
        visit login_manual_path # Assuming you have a login path
        fill_in 'Password', with: 'TxAMHeat#2k13'
        click_on 'Submit'
    end

    it 'valid inputs' do
        # Navigates and fills out the new member form
        visit new_member_path
        fill_in 'member[name]', with: 'John Cena'
        fill_in 'member[points]', with: 100
        fill_in 'member[email]', with: 'john@example.com'
        check 'member[dues_paid]'
        select 'Officer', from: 'member[position]'
        click_on 'Save Member'

        # Checks in the show page that the member is correctly displayed
        member = Member.find_by(email: 'john@example.com')
        visit member_path(member)
        expect(page).to have_content('Member name: John Cena')
        expect(page).to have_content('Member points: 100')
        expect(page).to have_content('Dues Paid: Yes')
        expect(page).to have_content('Position: Officer')
    end
end