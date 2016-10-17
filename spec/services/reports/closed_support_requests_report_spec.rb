require 'rails_helper'

RSpec.describe Reports::ClosedSupportRequestsReport do
  before do
    Timecop.travel(current_time)
  end
  let(:current_time) { Time.zone.local(2016, 8, 1, 13, 30) }
  subject { described_class.new }

  describe '#file_name' do
    it { expect(subject.file_name).to eql("month report for  1 Aug 2016 в 13:30") }
  end

  describe '#scope' do
    before do
      Timecop.travel(current_time - 2.month)
      old_closed_records
      Timecop.travel(current_time - 1.hour)
      closed_records
      not_closed_records
      Timecop.travel(current_time)
    end
    let(:closed_records) { create_list(:support_request, 2, status: 'closed') }
    let(:old_closed_records) { create_list(:support_request, 2, status: 'closed') }
    let(:not_closed_records) { create_list(:support_request, 3, status: 'open') }
    it 'include only closed records for this month' do
      expect(subject.scope).to include(*closed_records)
      expect(subject.scope).to_not include(*old_closed_records)
      expect(subject.scope).to_not include(*not_closed_records)
    end
  end

end
