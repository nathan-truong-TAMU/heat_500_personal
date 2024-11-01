require 'rails_helper'

RSpec.describe "announcements/edit", type: :view do
  let(:announcement) {
    Announcements.create!()
  }

  before(:each) do
    assign(:announcement, announcement)
  end

  it "renders the edit announcements form" do
    render

    assert_select "form[action=?][method=?]", announcements_path(announcement), "post" do
    end
  end
end
