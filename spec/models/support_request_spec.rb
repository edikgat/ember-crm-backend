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
  context 'closed at' do
    before do
      Timecop.travel current_time
    end
    let(:current_time) { Time.zone.local(2016, 8, 1, 13, 30) }
    context 'closed status' do
      subject { create(:support_request, status: 'closed') }
      it 'set closed_at after set status to nil' do
        expect { subject.update(status: 'open') }.to change { subject.closed_at }.to(nil)
      end
    end
    context 'not closed status' do
      subject { create(:support_request, status: 'open') }
      it 'set current time as closed_at' do
        expect { subject.update(status: 'closed') }.to change { subject.closed_at.to_i }.from(0).to(current_time.to_i)
      end
    end
  end

end


