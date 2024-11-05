require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    # Allows Admin View
    allow(view).to receive(:session).and_return({ authenticated: 'Admin', view_mode: 'Admin' })

    # Assign the event for the view
    assign(:event, @event)

    # Create a valid event instance with necessary attributes
    @event = assign(:event, Event.create!(
                              link: '/',
                              name: 'YouTuber Event',
                              description: 'Here, we will be YouTubing on the most YouTube ever.',
                              end_date: '2000-01-01 00:00:00',
                              start_date: '1999-12-31 23:59:00',
                              points: 10
                            ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do
      assert_select "input[name=?]", "event[name]", value: @event.name
      assert_select "input[name=?]", "event[link]", value: @event.link
      assert_select "input[name=?]", "event[description]", value: @event.description # Check for value
      assert_select "input[name=?]", "event[points]", value: @event.points
      assert_select "input[name=?]", "event[start_date]", value: @event.start_date.strftime("%Y-%m-%dT%H:%M")
      assert_select "input[name=?]", "event[end_date]", value: @event.end_date.strftime("%Y-%m-%dT%H:%M")
    end
  end
end
