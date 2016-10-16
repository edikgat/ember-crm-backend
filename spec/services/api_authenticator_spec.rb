require 'rails_helper'

RSpec.describe APIAuthenticator do
  let(:api_log_in) do
    log_in = APILogIn.new(resource.id, resource.class)
    log_in.process
    log_in
  end
  let(:token) { api_log_in.token }
  let!(:resource) { create(:user) }
  subject { described_class.new(token, resource.class) }
  describe '#process' do
    shared_examples_for 'process token' do
      context 'token present' do
        it 'returns true' do
          expect(subject.process).to be_truthy
        end
      end
      context 'token not present' do
        subject { described_class.new("#{token}-invalid", resource.class) }
        it 'returns false' do
          expect(subject.process).to be_falsey
        end
      end
    end
    context 'User' do
      it_behaves_like 'process token'
    end
    context 'SupportAgent' do
      let!(:resource) { create(:support_agent) }
      it_behaves_like 'process token'
    end
  end
  describe '#resource' do
    before do
      subject.process
    end
    shared_examples_for 'returns correct resource' do
      it 'returns correct resource' do
        expect(subject.resource).to eql(resource)
      end
    end
    context 'User' do
      it_behaves_like 'returns correct resource'
    end
    context 'SupportAgent' do
      let!(:resource) { create(:support_agent) }
      it_behaves_like 'returns correct resource'
    end
  end
  describe '#destroy' do
    shared_examples_for 'removes token' do
      context 'token present' do
        it 'returns true' do
          expect(subject.destroy).to be_truthy
        end
        it 'removes token from redis' do
          expect { subject.destroy }.to change { $redis.get("#{resource.class.to_s}:#{token}") }.to(nil)
        end
      end
      context 'token not present' do
        subject { described_class.new("#{token}-invalid", resource.class) }
        it 'returns false' do
          expect(subject.destroy).to be_falsey
        end
      end
    end
    context 'User' do
      it_behaves_like 'removes token'
    end
    context 'SupportAgent' do
      let!(:resource) { create(:support_agent) }
      it_behaves_like 'removes token'
    end

  end
end
