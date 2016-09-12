class Api::SupportAgentsApi::Auth < Api::SupportAgentsApi::Base

  resource :auth_token do
    desc 'Authenticate'
    params do
      requires :support_agent, type: Hash do
        optional :email, type: String
        optional :password, type: String
      end
    end
    post do
      support_agent = SupportAgent.find_by(email: permitted_params[:support_agent][:email])
      if support_agent && support_agent.valid_password?(permitted_params[:support_agent][:password])
        authenticator = APILogIn.new(support_agent.id, SupportAgent)
        authenticator.process
        status 201
        {
          token: authenticator.token,
          email: support_agent.email
        }
      else
        status 422
        {"error":"invalid password or email"}
      end
    end
  end

end
