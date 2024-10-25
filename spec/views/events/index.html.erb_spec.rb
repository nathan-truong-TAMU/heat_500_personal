require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    # Create valid event instances with necessary attributes
    @event1 = Event.create!(
      link: '/',
      name: 'First Event',
      description: 'This is the first event.',
      end_date: '2000-01-01 00:00:00',
      start_date: '1999-12-31 23:59:00',
      points: 10
    )
    
    @event2 = Event.create!(
      link: '/',
      name: 'Second Event',
      description: 'This is the second event.',
      end_date: '2001-01-01 00:00:00',
      start_date: '2000-12-31 23:59:00',
      points: 20
    )

    assign(:events, [@event1, @event2])

    # Allows Admin View
    allow(view).to receive(:session).and_return({ authenticated: 'Admin', view_mode: 'Admin' })
  end

  it "renders a list of events" do
    render
    
    # Check if the page contains the event names
    expect(rendered).to include(@event1.name)
    expect(rendered).to include(@event2.name)
    
    # Check if the page contains the event descriptions
    expect(rendered).to include(@event1.description)
    expect(rendered).to include(@event2.description)
  end
end