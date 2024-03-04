# frozen_string_literal: true

require 'csv' 
class HoleDetailsController < ApplicationController
  PAGE_SIZE = 1

  before_action :set_uploaded_file, only: %i[create]
  before_action :extract_hole_id_and_csv_data, only: %i[create]
  before_action :get_hole_details, only: %i[index another_method]
  before_action :authenticate_request

  def index
    if @hole_details.present?
      extract_key_and_hole_id
      headers = generate_headers
      response_data = generate_response_data
      render_response(headers, response_data)
    else
      render_empty_response
    end
  end

  def create
    parsed_data = @values.map { |row| Hash[@keys.zip(row)] }
    find_or_create_hole_detail(parsed_data)

    response_data = extract_response_data
    render_create_response(create_headers, response_data)
  rescue => e
    render_error_response(e)
  end

  private

  def get_hole_details
    @hole_details = HoleDetail.page(params[:page].to_i || 1).per(PAGE_SIZE)
  end

  def extract_key_and_hole_id
    extract_hole_id(@hole_details[0].hole_id)
    @keys = @hole_details&.first&.try(:csv_data)[0].keys || []
  end

  def extract_hole_id(hole_id)
    @hole = Hole.find_by(hole_id: hole_id)
  end

  def extract_hole_id_and_csv_data
    @hole_id = File.basename(@file, File.extname(@file))
    csv_data = CSV.read(@uploaded_file)
    @keys = csv_data.first
    @values = csv_data[1..]
  end

  def render_create_response(headers, response_data)
    render json: { 
      data: { 
        header_data: headers,
        records: response_data['csv_data']
      } 
    }, status: :ok
  end

  def render_response(headers, response_data)
    render json: {
      data: {
        file_name: "#{@hole_details.first.hole_id}.csv",
        header_data: headers,
        records: response_data[0]['csv_data'],
        metadata: page_meta(@hole_details)
      }
    }, status: :ok
  end

  def find_or_create_hole_detail(parsed_data)
    @hole_detail = HoleDetail.find_or_create_by(hole_id: @hole_id) 
    @hole_detail.update(csv_data: parsed_data)
  end

  def set_uploaded_file
    if params[:file].present?
      @uploaded_file = params[:file]
      @file = @uploaded_file.original_filename
    else
      render json: { message: "Please upload the file" }
    end
  end

  def extract_response_data
    @hole_detail&.attributes&.slice('hole_id', 'csv_data') || {}
  end

  def create_headers
    @keys[1..].map { |key| { "header_title" => key } }
  end

  def generate_headers
    @keys[1..].map { |key| { "header_title" => key, "start_point_z" => @hole.start_point_z, "end_point_z" => @hole.end_point_z } }
  end

  def generate_response_data
    @hole_details&.map { |record| record&.slice('csv_data') } || []
  end
end
