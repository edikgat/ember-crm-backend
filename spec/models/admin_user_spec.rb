require 'rails_helper'
RSpec.describe AdminUser, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
