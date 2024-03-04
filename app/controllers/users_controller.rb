# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request, only: :destroy

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: {
        message: 'Login successfully',
        token: token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    token = request.headers['token']&.split(' ')&.last
    BlacklistedToken.create(token: token) if token.present?
    render json: { message: 'Logout Successfully' }
  end
end
