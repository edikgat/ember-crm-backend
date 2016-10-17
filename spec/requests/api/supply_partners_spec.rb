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

    shared_examples_for 'authenticated support agents requests' do

      describe 'PUT /api/support_agents/v1/support_requests/:id' do
        let(:request) { create(:support_request, notes: 'notes', status: 'open', subject: 'subject') }
        let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json,
                                support_request: {notes: 'new notes', status: 'closed', subject: 'new subject'}} }
        context 'valid' do
          it 'update subject' do
            expect put(*request_array)
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                    a_hash_including("notes" => "new notes", 'status' => "closed", 'subject' => 'new subject')))
            expect(request.reload.closed_at.present?).to be_truthy
          end
        end
      end
      describe 'GET /api/support_agents/v1/support_requests/:id' do
        let!(:request) { create(:support_request, subject: 'subject') }
        let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'return subject' do
            expect get(*request_array)
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                    a_hash_including("subject" => "subject")))
          end
        end
      end
      describe 'GET /api/support_agents/v1/support_requests/' do
        let!(:request) { create(:support_request, subject: 'subject') }
        let(:url_path) { "/api/support_agents/v1/support_requests/" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'return subject' do
            expect get(*request_array)
            expect(response.status).to eq(200)
          end
        end
      end
      describe 'GET /api/support_agents/v1/support_requests/report.pdf' do
        let(:requests) { create_list(:support_request, 3, status: 'closed') }
        let(:url_path) { "/api/support_agents/v1/support_requests/report.pdf" }
        let(:request_params) { {format: :json} }
        let(:current_time) { Time.zone.local(2016, 8, 1, 13, 30) }
        before do
          Timecop.travel(current_time - 1.hour)
          requests
          Timecop.travel(current_time)
        end
        context 'valid' do
          it 'return subject' do
            expect get(*request_array)
            expect(response.status).to eq(200)
          end
        end
      end
      describe 'DELETE /api/support_agents/v1/support_requests/:id' do
        let!(:request) { create(:support_request, subject: 'subject') }
        let(:url_path) { "/api/support_agents/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'update subject' do
            expect{ delete(*request_array)}.to change { SupportRequest.count }
            expect(response.status).to eq(200)
          end
        end
      end

    end

    context 'with headers' do
      let(:headers) { {'Authorization' => {token: token, resource: 'support_agent'}.to_json} }
      let(:request_array) { [url_path, request_params, headers] }
      it_behaves_like 'authenticated support agents requests'
    end

    context 'with params' do
      let(:request_array) { [url_path, request_params.merge({'Authorization' => {token: token, resource: 'support_agent'}.to_json}), {}] }
      it_behaves_like 'authenticated support agents requests'
    end
  end




end
