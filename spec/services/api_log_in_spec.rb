require 'rails_helper'

RSpec.describe APILogIn do
  subject { described_class.new(resource.id, resource.class) }
  describe '#process' do
    let!(:resource) { create(:user) }
    it 'create token' do
      expect { subject.process }.to change { subject.token }.from(nil)
    end
  end
  context 'redis' do
    before do
      subject.process
    end
    context 'token key' do
      context 'User' do
        let!(:resource) { create(:user) }
        it 'stores in redis with valid resource prefix' do
          expect($redis.get("User:#{subject.token}")).to_not be_nil
        end
      end
      context 'SupportAgent' do
        let!(:resource) { create(:support_agent) }
        it 'stores in redis with valid resource prefix' do
          expect($redis.get("SupportAgent:#{subject.token}")).to_not be_nil
        end
      end
    end

    context 'redis token value' do
      let!(:resource) { create(:user) }
      it 'stores resource id' do
        expect(JSON.parse($redis.get("User:#{subject.token}"))['resource_id']).to eql(resource.id)
      end
    end
  end
end
