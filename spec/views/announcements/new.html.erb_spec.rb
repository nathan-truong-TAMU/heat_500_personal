require 'rails_helper'

RSpec.describe "announcements/new", type: :view do
  before(:each) do
    assign(:announcement, Announcements.new)
  end

  it "renders new announcements form" do
    render

    assert_select "form[action=?][method=?]", announcements_index_path, "post" do
    end
  end
end
