require "grape-swagger"

class Api::V1 < Grape::API
  prefix :api
  format :json
  content_type :json, 'application/json; charset=UTF-8'
  default_format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response(message: e.message, status: 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error_response(message: e.message, status: 422)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error_response(message: e.message, status: 422)
  end

  helpers do
    def authenticate_resource!(resource_name, resource_class)
      auth_hash = JSON.parse(request.headers['Authorization']) rescue {}
      if auth_hash.blank?
        auth_hash = JSON.parse(params[:Authorization]) || {}
      end
      authenticator = APIAuthenticator.new(auth_hash['token'], resource_class)
      if auth_hash['resource'] == resource_name && authenticator.process
        @resource = authenticator.resource
      else
        error!('auth.unauthorized', 401)
      end
    end

    def represent_for(object, with:)
      if object.is_a? ::ActiveRecord::Relation
        object = object.to_a
      end
      with.represent(object).as_json
    end

    def permitted_params
      @permitted_params ||= declared(params, include_missing: false)
    end


    def logger
      Rails.logger
    end

  end

  before do
    header 'Content-Type', 'application/json; charset=UTF-8'
  end

  mount Api::SupportAgentsApi::Base
  mount Api::UsersApi::Base

  add_swagger_documentation(
    api_version: "v1",
    hide_documentation_path: true,
    mount_path: "v1/swagger_doc",
    hide_format: true
  )
end
