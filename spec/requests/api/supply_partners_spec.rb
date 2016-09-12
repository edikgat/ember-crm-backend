require 'rails_helper'

describe 'supply partners auth' do

  describe 'POST /api/supply_agents/v1/auth_token' do
    let!(:agent) { create(:support_agent, password: 12345, password_confirmation: 12345, email: 'agent@test.com') }
    let(:url_path) { "/api/support_agents/v1/auth_token" }
    context 'correct email & password' do
      it 'should create token' do
         post url_path,
              format: :json,
              support_agent: {email: 'agent@test.com', password: 12345}
          expect(response.status).to eq(201)
          expect(JSON.parse(response.body)).to match(a_hash_including("token" => an_instance_of(String),
                                                                      "email" => 'agent@test.com'))
      end
    end
    context 'incorrect email & password' do
      it 'should return error' do
        post url_path,
            format: :json,
            support_agent: {email: 'agent@test.com', password: 12345678}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to match(a_hash_including("error" => "invalid password or email"))
      end
    end
  end

  context 'with authentication' do
    let(:user) { create(:support_agent) }
    let(:authenticator) do
      api = APILogIn.new(user.id, SupportAgent);
      api.process
      api
    end
    let(:token) { authenticator.token }
    let(:headers) { {'Authorization' => {token: token, resource: 'support_agent'}.to_json} }

    describe 'PUT /api/support_agents/v1/support_requests/:id' do
      let(:request) { create(:support_request, notes: 'notes', status: 'open') }
      let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
      context 'valid' do
        it 'update subject' do
          expect put(url_path,
                  {format: :json,
                  support_request: {notes: 'new notes', status: 'closed'}}, headers)
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                  a_hash_including("notes" => "new notes", 'status' => "closed")))
          expect(request.reload.closed_at.present?).to be_truthy
        end
      end
    end
    describe 'GET /api/support_agents/v1/support_requests/:id' do
      let!(:request) { create(:support_request, subject: 'subject') }
      let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
      context 'valid' do
        it 'return subject' do
          expect get(url_path,
                    {format: :json}, headers)
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                  a_hash_including("subject" => "subject")))
        end
      end
    end
    describe 'GET /api/support_agents/v1/support_requests/' do
      let!(:request) { create(:support_request, subject: 'subject') }
      let(:url_path) { "/api/support_agents/v1/support_requests/" }
      context 'valid' do
        it 'return subject' do
          expect get(url_path,
                    {format: :json}, headers)
          expect(response.status).to eq(200)
        end
      end
    end
    describe 'DELETE /api/support_agents/v1/support_requests/:id' do
      let!(:request) { create(:support_request, subject: 'subject') }
      let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
      context 'valid' do
        it 'update subject' do
          expect{ delete(url_path,
                  {format: :json}, headers)}.to change { SupportRequest.count }
          expect(response.status).to eq(200)
        end
      end
    end
  end




end
