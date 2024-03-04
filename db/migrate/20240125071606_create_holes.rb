class CreateHoles < ActiveRecord::Migration[7.1]
  def change
    create_table :holes, primary_key: [:hole_id] do |t|
      t.string :hole_id
      t.integer :hole_name
      t.float :start_point_x
      t.float :start_point_y
      t.float :start_point_z
      t.float :end_point_x
      t.float :end_point_y
      t.float :end_point_z
      t.timestamps
    end
  end
end
