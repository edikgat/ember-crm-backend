class Api::SupportAgentsApi::Base < Grape::API
  version 'v1', using: :path
  prefix 'api/support_agents'
  format :json


  helpers do
    def authenticate_user!
      auth_hash = JSON.parse(request.headers['Authorization']) rescue {}
      authenticator = APIAuthenticator.new(auth_hash['token'], SupportAgent)
      if auth_hash['resource'] == 'support_agent' && authenticator.process
        @support_agent = authenticator.resource
      else
        error!('auth.unauthorized', 401)
      end
    end

    def current_agent
      @support_agent
    end
  end

  resource :support_requests do
    desc "Support requests report for currect month"
    get '/report' do
      report = Reports::ClosedSupportRequestsReport.new
      content_type "application/pdf"
      header['Content-Disposition'] = "attachment; filename=#{report.file_name}"
      env['api.format'] = :binary
      body report.render_report
    end
  end

  mount SupportRequests
  mount Auth

end
