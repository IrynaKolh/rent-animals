require 'rails_helper'

RSpec.describe "Pets Non-Seller Requests", type: :request do
    before(:each) do
        ActiveRecord::Base.transaction do
          @seller = FactoryBot.create(:user, seller: true)
          @pets = FactoryBot.create_list(:pet, 10, user: @seller)
        end
    end

  describe "GET /pets" do
    it "allows non-sellers to view pets" do
      get pets_path
      expect(response).to have_http_status(:success)
      expect(assigns(:pets).length).to eq(10)
    end
  end

  describe "POST /pets" do
    let(:pet_attributes) do
        {
          name: "Raccoon",
          description: "Aut saepe excepturi.",
          price: 70.0,
          age: 13,
          category: "cat",
          delivery_to_client: false,
          insuranse: true,
          image: [Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/cat.jpg'), 'image/jpeg')]
        }
    end

    it "does not allow non-sellers to create a pet" do       
      post pets_path, params: { pet: pet_attributes }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
