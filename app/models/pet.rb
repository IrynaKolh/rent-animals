class Pet < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_many_attached :image
  enum category: { dog: 0, cat: 1, bird: 2, rabbit: 3, reptile: 4, horse: 5, goat: 6, small_animal: 7, other: 8 }

   # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true, inclusion: { in: categories.keys }  
  validates :description, presence: true
end
