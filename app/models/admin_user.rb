class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true
end
