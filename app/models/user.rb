class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, password_strength: true, if: :password_required?
  validates :seller, inclusion: { in: [true, false] }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets

  private

  def password_required?
    # A password is required if the user is new or if the password has been changed
    new_record? || password.present?
  end
  
end
