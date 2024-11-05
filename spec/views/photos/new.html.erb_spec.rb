require 'rails_helper'

RSpec.describe "photos/new", type: :view do
  before(:each) do
    assign(:photo, Photo.new(
                     path: "MyString",
                     alt_text: "MyString",
                     description: "MyString"
                   ))
  end

  it "renders new photo form" do
    render

    assert_select "form[action=?][method=?]", photos_path, "post" do
      assert_select "input[name=?]", "photo[path]"

      assert_select "input[name=?]", "photo[alt_text]"

      assert_select "input[name=?]", "photo[description]"
    end
  end
end
