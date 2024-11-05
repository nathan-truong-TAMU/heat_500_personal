require 'rails_helper'

RSpec.describe "photos/show", type: :view do
  before(:each) do
    assign(:photo, Photo.create!(
                     path: "Path",
                     alt_text: "Alt Text",
                     description: "Description"
                   ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Path/)
    expect(rendered).to match(/Alt Text/)
    expect(rendered).to match(/Description/)
  end
end
