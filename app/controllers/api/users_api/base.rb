class Api::UsersApi::Base < Grape::API
  version 'v1', using: :path
  prefix 'api/users'
  format :json


  helpers do
    def authenticate_user!
      authenticate_resource!('user', User)
    end

    def current_user
      @resource
    end
  end

  mount SupportRequests
  mount Auth

end
