class SupportAgent < ActiveRecord::Base

  validates :email, presence: true
  validates :password, :password_confirmation, :first_name, :last_name, presence: true, on: :create
  validates :password, confirmation: true
  validates :email, uniqueness: { case_sensitive: false }, email: true, allow_blank: true

  devise :database_authenticatable
end
