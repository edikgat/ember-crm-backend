FactoryGirl.define do
  factory :support_request do
    sequence(:subject) { |n| "#{n}_#{Faker::Company.bs}" }
    status { SupportRequest::AVALIABLE_STATUSES.sample }
    association :user
    notes { Faker::Lorem.sentence }
  end
end
