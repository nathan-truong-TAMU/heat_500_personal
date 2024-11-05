require 'rails_helper'

RSpec.describe "members/index", type: :view do
  before(:each) do
    # Create valid member instances with necessary attributes
    @member1 = Member.create!(
      name: 'John Doe',
      points: 100,
      dues_paid: true,
      position: 'Officer'
    )

    @member2 = Member.create!(
      name: 'Jane Smith',
      points: 150,
      dues_paid: false,
      position: 'Member'
    )

    assign(:members, [@member1, @member2])

    # Allows Admin View
    allow(view).to receive(:session).and_return({ authenticated: 'Admin', view_mode: 'Admin' })
  end

  it "renders a list of members" do
    render

    # Check if the page contains the member names
    expect(rendered).to include(@member1.name)
    expect(rendered).to include(@member2.name)

    # Check if the page contains the member points
    expect(rendered).to include(@member1.points.to_s)
    expect(rendered).to include(@member2.points.to_s)

    # Check if the page indicates dues status
    expect(rendered).to include(@member1.dues_paid ? 'Yes' : 'No')
    expect(rendered).to include(@member2.dues_paid ? 'Yes' : 'No')

    # Check if the page contains the member positions
    expect(rendered).to include(@member1.position)
    expect(rendered).to include(@member2.position)
  end
end
