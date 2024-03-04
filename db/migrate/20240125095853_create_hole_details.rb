class CreateHoleDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :hole_details do |t|
      t.json :csv_data
      t.integer :hole_id
      
      t.timestamps
    end
  end
end
