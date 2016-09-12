require 'factory_girl_rails'

AdminUser.create!(email: 'admin@test.com', password: 12345678, password_confirmation: 12345678)
SupportAgent.create!(email: 'agent@test.com', password: 12345678, password_confirmation: 12345678, first_name: 'first', last_name: 'agent')
user = User.create!(email: 'user@test.com', password: 12345678, password_confirmation: 12345678, first_name: 'first', last_name: 'user')
FactoryGirl.create_list(:support_agent, 5)
10.times do |i|
  FactoryGirl.create_list(:support_request, 5, user: user)
end

10.times do |i|
  other_user = FactoryGirl.create(:user)
  10.times do
    FactoryGirl.create_list(:support_request, 5, user: other_user)
  end
end

