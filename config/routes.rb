Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  if Rails.env.development?
    mount GrapeSwaggerRails::Engine, at: "/documentation"
  end
  mount Api::V1 => '/'

end
