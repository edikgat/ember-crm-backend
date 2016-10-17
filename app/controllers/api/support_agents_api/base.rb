class Api::SupportAgentsApi::Base < Grape::API
  version 'v1', using: :path
  prefix 'api/support_agents'
  format :json


  helpers do
    def authenticate_user!
      authenticate_resource!('support_agent', SupportAgent)
    end

    def current_agent
      @resource
    end
  end

  mount SupportRequests
  mount Auth

end
