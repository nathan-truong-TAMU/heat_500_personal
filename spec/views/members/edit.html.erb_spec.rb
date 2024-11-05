require 'rails_helper'

RSpec.describe "members/edit", type: :view do
  let(:member) do
    Member.create!(
      name: 'John Cena',
      points: 100,
      dues_paid: true,
      position: 'Officer'
    )
  end

  before(:each) do
    assign(:member, member)
    render # Render the view so we can check its output
  end

  it "renders the edit member form" do
    assert_select "form[action=?][method=?]", member_path(member), "post" do
      assert_select "input[name=?]", "member[name]", value: member.name
      assert_select "input[name=?]", "member[points]", value: member.points
      assert_select "input[name=?]", "member[dues_paid]", checked: member.dues_paid # Check if dues_paid is checked

      # Check the select field for position
      assert_select "select[name=?]", "member[position]" do
        assert_select "option", text: 'Officer', selected: true # Verify that 'Officer' is the selected option
        assert_select "option", text: 'Member' # Check if 'Member' is present
        assert_select "option", text: 'Admin' # Check if 'Admin' is present
      end

      assert_select "input[type=submit]" # Check for a submit button
    end
  end
end
