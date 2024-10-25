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

RSpec.describe "/events", type: :request do
  before do
    post login_path, params: {password: 'TxAMHeat#2k13'}
  end

  # This should return the minimal set of attributes required to create a valid
  # Event. As you add validations to Event, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Event.create! valid_attributes
      get events_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      event = Event.create! valid_attributes
      get event_url(event)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_event_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      event = Event.create! valid_attributes
      get edit_event_url(event)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Event" do
        expect {
          post events_url, params: { event: valid_attributes }
        }.to change(Event, :count).by(1)
      end

      it "redirects to the created event" do
        post events_url, params: { event: valid_attributes }
        expect(response).to redirect_to(event_url(Event.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Event" do
        expect {
          post events_url, params: { event: invalid_attributes }
        }.to change(Event, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post events_url, params: { event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        patch event_url(event), params: { event: new_attributes }
        event.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        patch event_url(event), params: { event: new_attributes }
        event.reload
        expect(response).to redirect_to(event_url(event))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        event = Event.create! valid_attributes
        patch event_url(event), params: { event: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete event_url(event)
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete event_url(event)
      expect(response).to redirect_to(events_url)
    end
  end
end
