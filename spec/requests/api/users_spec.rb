require 'rails_helper'

describe 'users auth' do

  describe 'POST /api/users/v1/auth_token' do
    let!(:user) { create(:user, password: 12345, password_confirmation: 12345, email: 'user@test.com') }
    let(:url_path) { "/api/users/v1/auth_token" }
    context 'correct email & password' do
      it 'should create token' do
         post url_path,
              format: :json,
              user: {email: 'user@test.com', password: 12345}
          expect(response.status).to eq(201)
          expect(JSON.parse(response.body)).to match(a_hash_including("token" => an_instance_of(String),
                                                                      "email" => 'user@test.com'))
      end
    end
    context 'incorrect email & password' do
      it 'should return error' do
        post url_path,
            format: :json,
            user: {email: 'user@test.com', password: 12345678}
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to match(a_hash_including("error" => "invalid password or email"))
      end
    end
  end

  describe 'POST /api/users/v1/users' do
    let(:url_path) { "/api/users/v1/users" }
    context 'correct params' do
      it 'should return email & password' do
         post url_path,
              format: :json,
              user: {email: 'user@test.com',
                     password: 12345,
                     password_confirmation: 12345,
                     first_name: 'first',
                     last_name: 'last'}
          expect(response.status).to eq(201)
          expect(JSON.parse(response.body)).to eql({'user'=> {'email'=>'user@test.com', 'password'=> '12345'}})
      end
      it 'should create user' do
         expect{post url_path,
                  format: :json,
                  user: {email: 'user@test.com',
                         password: 12345,
                         password_confirmation: 12345,
                         first_name: 'first',
                         last_name: 'last'}}.to change { User.count }
      end
    end
    context 'invalid params' do
      it 'should return email & password' do
         post url_path,
              format: :json,
              user: {email: 'user@test.com',
                     password: 1234456465,
                     password_confirmation: 12345,
                     first_name: 'first',
                     last_name: 'last'}
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)).to match(a_hash_including("errors" => an_instance_of(Hash)))
       end
    end
  end
  context 'with authentication' do
    let(:user) { create(:user) }
    let(:authenticator) do
      api = APILogIn.new(user.id, User);
      api.process
      api
    end
    let(:token) { authenticator.token }
    shared_examples_for 'authenticated users requests' do

      describe 'POST /api/users/v1/support_requests' do
        let(:url_path) { '/api/users/v1/support_requests' }
        context 'valid' do
          let(:request_params) { {format: :json,
                        support_request: {subject: 'subject'}} }
          it 'creates new support_request' do
           expect{ post(*request_array) }.to change { SupportRequest.count }
          end
          it 'creates new support_request' do
            expect post(*request_array)
            expect(response.status).to eq(201)
            expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                    a_hash_including("subject" => "subject",
                                     "user_name" => user.full_name,
                                     "status" => "open")))

          end
        end
        context 'no subject' do
          let(:request_params) { {format: :json,
                                  support_request: {subject: ''}} }
          it 'not create support request' do
           expect{ post(*request_array) }.to_not change { SupportRequest.count }
          end
        end
      end
      describe 'PUT /api/users/v1/support_requests/:id' do
        let(:request) { create(:support_request, subject: 'subject', user: user) }
        let(:url_path) { "/api/users/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json,
                                support_request: {subject: 'new subject'}} }
        context 'valid' do
          it 'update subject' do
            expect put(*request_array)
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                    a_hash_including("subject" => "new subject")))
          end
        end
        context 'other user' do
          let(:request) { create(:support_request, subject: 'subject') }
          it 'update subject' do
            expect put(*request_array)
            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)).to match(a_hash_including("error" => an_instance_of(String)))
          end
        end
      end
      describe 'GET /api/users/v1/support_requests/:id' do
        let!(:request) { create(:support_request, subject: 'subject', user: user) }
        let(:url_path) { "/api/users/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'return subject' do
            expect get(*request_array)
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to match(a_hash_including("support_request" =>
                    a_hash_including("subject" => "subject")))
          end
        end
        context 'other user' do
          let!(:request) { create(:support_request, subject: 'subject') }
          it 'update subject' do
            expect get(*request_array)
            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)).to match(a_hash_including("error" => an_instance_of(String)))
          end
        end
      end
      describe 'GET /api/users/v1/support_requests/' do
        let!(:request) { create(:support_request, subject: 'subject', user: user) }
        let(:url_path) { "/api/users/v1/support_requests/" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'return subject' do
            expect get(*request_array)
            expect(response.status).to eq(200)
          end
        end
      end
      describe 'DELETE /api/users/v1/support_requests/:id' do
        let!(:request) { create(:support_request, subject: 'subject', user: user) }
        let(:url_path) { "/api/users/v1/support_requests/#{request.id}" }
        let(:request_params) { {format: :json} }
        context 'valid' do
          it 'update subject' do
            expect{ delete(*request_array)}.to change { SupportRequest.count }
            expect(response.status).to eq(200)
          end
        end
        context 'other user' do
          let!(:request) { create(:support_request, subject: 'subject') }
          it 'update subject' do
            expect delete(*request_array)
            expect(response.status).to eq(404)
            expect(JSON.parse(response.body)).to match(a_hash_including("error" => an_instance_of(String)))
          end
        end
      end

    end

    context 'with headers' do
      let(:headers) { {'Authorization' => {token: token, resource: 'user'}.to_json} }
      let(:request_array) { [url_path, request_params, headers] }
      it_behaves_like 'authenticated users requests'
    end

    context 'with params' do
      let(:request_array) { [url_path, request_params.merge({'Authorization' => {token: token, resource: 'user'}.to_json}), {}] }
      it_behaves_like 'authenticated users requests'
    end


  end




end
