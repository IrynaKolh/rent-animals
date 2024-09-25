json.extract! pet, :id, :name, :description, :price, :age, :category, :delivery_to_client, :insuranse, :image, :user_id, :created_at, :updated_at
json.url pet_url(pet, format: :json)
json.description pet.description.to_s
json.image do
  json.array!(pet.image) do |image|
    json.id image.id
    json.url url_for(image)
  end
end
