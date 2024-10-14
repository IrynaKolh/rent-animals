require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let(:user) { FactoryBot.create(:user, seller: true) }

  before(:each) do
    sign_in user
  end
  
  describe "GET /pets" do

    before do
      @pets = FactoryBot.create_list(:pet, 12, user: user)
    end

    it "returns a successful response" do
      get pets_path
      expect(response).to have_http_status(200)
    end

    it "returns a list of pets" do
      get pets_path
      expect(response).to render_template(:index)
      expect(assigns(:pets).length).to eq(12)
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
        user_id: user.id,
        image: [Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/cat.jpg'), 'image/jpeg')]
      }
    end
  
    it "creates a new pet" do  
      expect {
        post pets_path, params: { pet: pet_attributes }
      }.to change(Pet, :count).by(1)
  
      created_pet = Pet.last
      expect(response).to redirect_to(pet_path(created_pet))
    end
  end

  describe "PATCH /pets/:id" do
    let(:pet) { FactoryBot.create(:pet, user: user) } 

    it "updates an existing pet" do
      patch pet_path(pet), params: { pet: { name: "Max", price: 70.0 } }
      pet.reload 
      expect(pet.name).to eq("Max")
      expect(pet.price).to eq(70.0)
      expect(response).to redirect_to(pet_path(pet)) 
    end
  end

  describe "DELETE /pets/:id" do
    let(:pet) { FactoryBot.create(:pet, user: user) } 

    it "deletes an existing pet" do
      pet 
      expect {
        delete pet_path(pet)
      }.to change(Pet, :count).by(-1)

      expect(response).to redirect_to(pets_path) 
    end
  end  

end
