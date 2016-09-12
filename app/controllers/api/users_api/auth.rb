class Api::UsersApi::Auth < Api::UsersApi::Base

  resource :auth_token do

    desc 'Authenticate'
    params do
      requires :user, type: Hash do
        optional :email, type: String
        optional :password, type: String
      end
    end
    post do
      user = User.find_by(email: permitted_params[:user][:email])
      if user && user.valid_password?(permitted_params[:user][:password])
        authenticator = APILogIn.new(user.id, User)
        authenticator.process
        status 201
        {
          token: authenticator.token,
          email: user.email
        }
      else
        status 422
        {"error":"invalid password or email"}
      end
    end
  end
  resource :users do
    desc 'sign up'
    params do
      requires :user, type: Hash do
        optional :first_name, type: String
        optional :last_name, type: String
        optional :email, type: String
        optional :password, type: String
        optional :password_confirmation, type: String
      end
    end
    post do
      user = User.new(permitted_params[:user])
      if user.save
        status 201
        {user: {email: user.email, password: user.password}}
      else
        status 422
        {errors: user.errors.to_h}
      end
    end
  end

end

