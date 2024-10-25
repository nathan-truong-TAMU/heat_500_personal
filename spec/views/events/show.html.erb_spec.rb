require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = Event.create!(
      link: '/',
      name: 'YouTuber Event',
      description: 'Here, we will be YouTubing on the most YouTube ever.',
      end_date: '2000-01-01 00:00:00',
      start_date: '1999-12-31 23:59:00',
      points: 10
    )
    
    assign(:event, @event)
  end

  it "renders attributes in <p>" do
    render

    # Check if the rendered page contains the event attributes
    expect(rendered).to include(@event.link)
    expect(rendered).to include(@event.name)
    expect(rendered).to include(@event.description)

    # Adjust the date format according to your view
    expect(rendered).to include(@event.end_date.strftime("%A, %d %B %Y at %I:%M %p")) 
    expect(rendered).to include(@event.start_date.strftime("%A, %d %B %Y at %I:%M %p"))
    
    expect(rendered).to include(@event.points.to_s)
  end
end
