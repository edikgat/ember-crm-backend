require 'rails_helper'
RSpec.describe User, type: :model do
  subject { build(:user) }
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it_behaves_like 'email validation examples'
  end
  context 'associations' do
    it { should have_many(:support_requests).dependent(:destroy) }
  end

end


