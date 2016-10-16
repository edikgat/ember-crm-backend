require 'rails_helper'

RSpec.describe SupportRequest, type: :model do
  subject { build(:support_request) }
  context 'validations' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array(%w(open closed canceled)) }
    it { is_expected.to validate_uniqueness_of(:subject).scoped_to(:user_id).case_insensitive }
  end
  context 'associations' do
    it { should belong_to(:user) }
  end

end


