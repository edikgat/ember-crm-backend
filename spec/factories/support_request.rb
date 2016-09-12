FactoryGirl.define do
  factory :support_request do
    subject { Faker::Company.bs }
    status { SupportRequest::AVALIABLE_STATUSES.sample }
    association :user
    notes { Faker::Lorem.sentence }
  end
end
