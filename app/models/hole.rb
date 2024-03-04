# frozen_string_literal: true

class Hole < ApplicationRecord
  require 'csv'
  has_many :hole_details, dependent: :destroy

  def self.import(file)
    begin
      opened_file = File.open(file)
      options = { headers: true }
      CSV.foreach(opened_file, **options) do |row|
        hole = Hole.find_by(hole_id: row['HoleId'])
        if hole.present?
          hole.update(get_raw_data(row))
        else
          hole_data = Hole.create(get_raw_data(row))
        end
      end
      hole_data
    rescue StandardError => e
      puts "Error importing data: #{e.message}"
    ensure
      opened_file.close if opened_file
    end
  end

  private

  def self.get_raw_data(row)
    { 
      hole_id: row['HoleId'],
      hole_name: row['HoleName'],
      start_point_x: row['StartPointX'],
      start_point_y: row['StartPointY'],
      start_point_z: row['StartPointZ'],
      end_point_x: row['EndPointX'],
      end_point_y: row['EndPointY'],
      end_point_z: row['EndPointZ']
    }
  end
end

