require 'faker'

FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Animal.name }  
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 5..250) }
    age { Faker::Number.between(from: 0, to: 15) } 
    category { Pet.categories.keys.sample }
    delivery_to_client { Faker::Boolean.boolean } 
    insuranse { Faker::Boolean.boolean } 
    
    after(:build) do |pet|
      pet.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'cat.jpg')), filename: 'cat.jpg', content_type: 'image/jpg')
    end

    association :user 
  end
end
