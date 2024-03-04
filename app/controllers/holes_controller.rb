# frozen_string_literal: true

class HolesController < ApplicationController
  before_action :authenticate_request

  def create
    holes = Hole.import(params[:file])
    if holes.present?
      render json: HoleSerializer.new(holes).serializable_hash
    else
      render json: Hole.all, each_serializer: HoleSerializer
    end
  end
end
