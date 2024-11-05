require 'rails_helper'

RSpec.describe "photos/edit", type: :view do
  let(:photo) do
    Photo.create!(
      path: "MyString",
      alt_text: "MyString",
      description: "MyString"
    )
  end

  before(:each) do
    assign(:photo, photo)
  end

  it "renders the edit photo form" do
    render

    assert_select "form[action=?][method=?]", photo_path(photo), "post" do
      assert_select "input[name=?]", "photo[path]"

      assert_select "input[name=?]", "photo[alt_text]"

      assert_select "input[name=?]", "photo[description]"
    end
  end
end
