FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    password 12345678
    password_confirmation 12345678
  end
end
