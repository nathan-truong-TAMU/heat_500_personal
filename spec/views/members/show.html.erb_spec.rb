require 'rails_helper'

RSpec.describe "members/show", type: :view do
  let(:member) do
    Member.create!(
      name: 'John Doe',
      points: 100,
      dues_paid: true,
      position: 'Officer'
    )
  end

  before(:each) do
    assign(:member, member) # Assign the member to the view

    # Allows Admin View
    allow(view).to receive(:session).and_return({ authenticated: 'Admin', view_mode: 'Admin' })
  end

  it "renders attributes in <p>" do
    render

    # Check if the page contains the member's name
    expect(rendered).to include("#{member.name}")

    # Check if the page contains the member's points
    expect(rendered).to include("#{member.points}")
  end
end
