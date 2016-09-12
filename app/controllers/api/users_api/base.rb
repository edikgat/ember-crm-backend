class Api::UsersApi::Base < Grape::API
  version 'v1', using: :path
  prefix 'api/users'
  format :json


  helpers do
    def authenticate_user!
      auth_hash = JSON.parse(request.headers['Authorization']) rescue {}
      authenticator = APIAuthenticator.new(auth_hash['token'], User)
      if auth_hash['resource'] == 'user' && authenticator.process
        @user = authenticator.resource
      else
        error!('auth.unauthorized', 401)
      end
    end

    def current_user
      @user
    end
  end

  mount SupportRequests
  mount Auth

end
