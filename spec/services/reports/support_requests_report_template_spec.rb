require 'rails_helper'

RSpec.describe Reports::SupportRequestsReportTemplate do
  before do
    Timecop.travel current_time
  end
  let(:current_time) { Time.zone.local(2016, 8, 1, 13, 30) }
  let(:closed_records) { build_list(:support_request, 3, status: 'closed', closed_at: current_time) }
  subject { described_class.new(closed_records) }

  describe '#table_widths' do
    it { expect(subject.table_widths).to eql([150, 70, 100]) }
  end
  describe '#font_size' do
    it { expect(subject.font_size).to eql(10) }
  end
  describe '#organization' do
    it { expect(subject.organization).to eql('Crossover') }
  end
  describe '#title' do
    it { expect(subject.title).to eql('Closed Tickets Report') }
  end

  describe '#table_data' do
    let(:user) { create(:user, first_name: 'first', last_name: 'user') }
    let(:first_report) { create(:support_request, status: 'closed', subject: 'first report', user: user) }
    let(:second_report) { create(:support_request, status: 'closed', subject: 'second report', user: user) }
    let(:closed_records) { [first_report, second_report] }

    it { expect(subject.table_data).to eql([["Subject", "Date", "User"],
                                            ["first report", "08/01/16", "first user"],
                                            ["second report", "08/01/16", "first user"]]) }
  end

end
