# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  def authenticate_request
    begin
      header = request.headers['token']
      header = header.split(' ').last if header
      decoded = jwt_decode(header)
      if decoded.nil?
        render json: { message: 'Invalid or expired token' }, status: :unauthorized
        return
      else
        @current_user = User.find(decoded[:user_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render_error_response(e)
    rescue JWT::DecodeError => e
      render_error_response(e)
    end
  end

  def render_empty_response
    render json: { data: {} }, status: :ok
  end

  def render_error_response(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def page_meta(data)
    {
      current_page: data.current_page,
      total_pages: data.total_pages
    }
  end
end
