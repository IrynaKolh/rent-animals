class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, password_strength: true, if: -> { password.present? && password_changed? }
  validates :seller, inclusion: { in: [true, false] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets
end
