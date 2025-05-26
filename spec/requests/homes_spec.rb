require 'rails_helper'

RSpec.describe "Homes", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      address: "123 Test St",
      city: "Test City",
      state: "Test State",
      zip: "12345",
      bedrooms: 3,
      baths: 2,
      square_feet: 1500,
      price: 250000,
      description: "A test home",
      created_by_id: user.id
    }
  end

  before do
    # Mock authentication - adjust this based on your actual authentication system
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /homes" do
    it "returns a successful response" do
      get homes_path
      expect(response).to be_successful
    end

    it "displays all homes" do
      home1 = create(:home, valid_attributes)
      home2 = create(:home, valid_attributes.merge(address: "456 Test St"))
      
      get homes_path
      expect(response.body).to include("Test City, Test State")
      expect(response.body).to include("12345")
      expect(response.body).to include("3 Beds")
      expect(response.body).to include("2 Baths")
      expect(response.body).to include("1500 sq. feet")
      expect(response.body).to include("250,000")
    end
  end

  describe "GET /homes/:id" do
    it "returns a successful response" do
      home = create(:home, valid_attributes)
      get home_path(home)
      expect(response).to be_successful
    end

    it "displays the home details" do
      home = create(:home, valid_attributes)
      get home_path(home)
      expect(response.body).to include(home.address)
      expect(response.body).to include(home.city)
      expect(response.body).to include(home.state)
    end
  end

  describe "GET /homes/new" do
    it "returns a successful response" do
      get new_home_path
      expect(response).to be_successful
    end
  end

  describe "POST /homes" do
    context "with valid parameters" do
      it "creates a new Home" do
        expect {
          post homes_path, params: { home: valid_attributes }
        }.to change(Home, :count).by(1)
      end

      it "redirects to the created home" do
        post homes_path, params: { home: valid_attributes }
        expect(response).to redirect_to(home_path(Home.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Home" do
        expect {
          post homes_path, params: { home: valid_attributes.merge(address: nil) }
        }.to change(Home, :count).by(0)
      end

      it "renders the new template" do
        post homes_path, params: { home: valid_attributes.merge(address: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /homes/:id/edit" do
    it "returns a successful response" do
      home = create(:home, valid_attributes)
      get edit_home_path(home)
      expect(response).to be_successful
    end
  end

  describe "PATCH /homes/:id" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          address: "789 New St",
          price: 300000
        }
      end

      it "updates the requested home" do
        home = create(:home, valid_attributes)
        patch home_path(home), params: { home: new_attributes }
        home.reload
        expect(home.address).to eq("789 New St")
        expect(home.price).to eq(300000)
      end

      it "redirects to the home" do
        home = create(:home, valid_attributes)
        patch home_path(home), params: { home: new_attributes }
        expect(response).to redirect_to(home_path(home))
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        home = create(:home, valid_attributes)
        patch home_path(home), params: { home: { address: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /homes/:id" do
    it "destroys the requested home" do
      home = create(:home, valid_attributes)
      expect {
        delete home_path(home)
      }.to change(Home, :count).by(-1)
    end

    it "redirects to the homes list" do
      home = create(:home, valid_attributes)
      delete home_path(home)
      expect(response).to redirect_to(homes_path)
    end
  end
end 