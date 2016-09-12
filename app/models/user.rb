class User < ActiveRecord::Base

  has_many :support_requests, inverse_of: :user, dependent: :destroy

  validates :email, presence: true
  validates :password, :password_confirmation, :first_name, :last_name, presence: true, on: :create
  validates :password, confirmation: true
  validates :email, uniqueness: { case_sensitive: false }

  devise :database_authenticatable

  def full_name
    "#{first_name} #{last_name}"
  end
end

