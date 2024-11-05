require 'rails_helper'

RSpec.describe "photos/index", type: :view do
  before(:each) do
    assign(:photos, [
      Photo.create!(
        path: "Path",
        alt_text: "Alt Text",
        description: "Description"
      ),
      Photo.create!(
        path: "Path",
        alt_text: "Alt Text",
        description: "Description"
      )
    ])
  end

  it "renders a list of photos" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Path".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Alt Text".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
  end
end
