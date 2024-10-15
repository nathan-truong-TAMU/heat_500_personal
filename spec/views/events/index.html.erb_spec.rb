require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(name: "Event 1", link: "Link 1", start_date: DateTime.now, end_date: DateTime.now),
      Event.create!(name: "Event 2", link: "Link 2", start_date: DateTime.now, end_date: DateTime.now)
    ])
  end

  it "renders a list of events" do
    render
    expect(rendered).to match(/Event 1/)
    expect(rendered).to match(/Event 2/)
    expect(rendered).to have_selector("div.event", count: 2)

  end
end
