require 'rails_helper'

RSpec.describe "announcements/index", type: :view do
  before(:each) do
    assign(:announcements, [
      Announcements.create!(),
      Announcements.create!()
    ])
  end

  it "renders a list of announcements" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
