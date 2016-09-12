class Api::SupportAgentsApi::SupportRequests < Api::SupportAgentsApi::Base

  before do
    authenticate_user!
  end

  helpers do
    def support_request_response_for(support_requests, root: :support_request)
      {root => represent_for(support_requests, with: SupportRequestPresenter)}
    end
  end

  resource :support_requests do

    desc "Return all support requests"
    get "" do
      support_request_response_for(SupportRequest.all.includes(:user), root: :support_request)
    end

    params do
      requires :id, type: Integer, desc: 'Status id.'
    end
    route_param :id do

      desc 'Return a support request.'
      get do
        support_request_response_for SupportRequest.find(permitted_params[:id])
      end

      desc 'Delete a support request'
      delete do
        support_request_response_for SupportRequest.find(params[:id]).destroy
      end
    end

    desc 'update support request'
    params do
      requires :id, type: Integer, desc: 'Support Request ID'
      requires :support_request, type: Hash do
        optional :status, type: String
        optional :notes, type: String
      end
    end
    route_param :id do
      route %w'PUT PATCH' do
        support_request = SupportRequest.find(permitted_params[:id])
        if support_request.update(permitted_params[:support_request])
          status 200
          support_request_response_for support_request
        else
          status 422
          {errors: support_request.errors.to_h}
        end
      end
    end

  end
end
