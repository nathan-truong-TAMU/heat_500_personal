require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/announcements", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Announcements. As you add validations to Announcements, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip("Add a hash of attributes valid for your model")
  end

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end

  describe "GET /index" do
    it "renders a successful response" do
      Announcements.create! valid_attributes
      get announcements_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      announcements = Announcements.create! valid_attributes
      get announcement_url(announcements)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_announcement_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      announcements = Announcements.create! valid_attributes
      get edit_announcement_url(announcements)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Announcements" do
        expect do
          post announcements_url, params: { announcement: valid_attributes }
        end.to change(Announcements, :count).by(1)
      end

      it "redirects to the created announcement" do
        post announcements_url, params: { announcement: valid_attributes }
        expect(response).to redirect_to(announcement_url(Announcements.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Announcements" do
        expect do
          post announcements_url, params: { announcement: invalid_attributes }
        end.to change(Announcements, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post announcements_url, params: { announcement: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        skip("Add a hash of attributes valid for your model")
      end

      it "updates the requested announcement" do
        announcements = Announcements.create! valid_attributes
        patch announcement_url(announcements), params: { announcement: new_attributes }
        announcements.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the announcement" do
        announcements = Announcements.create! valid_attributes
        patch announcement_url(announcements), params: { announcement: new_attributes }
        announcements.reload
        expect(response).to redirect_to(announcement_url(announcements))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        announcements = Announcements.create! valid_attributes
        patch announcement_url(announcements), params: { announcement: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested announcement" do
      announcements = Announcements.create! valid_attributes
      expect do
        delete announcement_url(announcements)
      end.to change(Announcements, :count).by(-1)
    end

    it "redirects to the announcements list" do
      announcements = Announcements.create! valid_attributes
      delete announcement_url(announcements)
      expect(response).to redirect_to(announcements_url)
    end
  end
end
