require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:user) { User.create(email: "user@example.com", password: "passWord123!") }
  subject { Pet.new(name: "Buddy", description: "A friendly dog", price: 50.0, age: 3, category: "dog", delivery_to_client: true, insuranse: false, user: user) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a price" do
    subject.price = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a price less than or equal to 0" do
    subject.price = 0
    expect(subject).to_not be_valid
  end

  it "is not valid without an age" do
    subject.age = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a negative age" do
    subject.age = -1
    expect(subject).to_not be_valid
  end

  it "is not valid without a category" do
    subject.category = nil
    expect(subject).to_not be_valid
  end

end
