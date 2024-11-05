require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new)

    # Allows Admin View
    allow(view).to receive(:session).and_return({ authenticated: 'Admin', view_mode: 'Admin' })
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do
      assert_select "input[name=?]", "event[link]"
      assert_select "input[name=?]", "event[name]"
      assert_select "input[name=?]", "event[description]" # Corrected to input
      assert_select "input[name=?]", "event[end_date]"
      assert_select "input[name=?]", "event[start_date]"
      assert_select "input[name=?]", "event[points]"
    end
  end
end
