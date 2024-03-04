class ChangeColumnTypeInHoleDetails < ActiveRecord::Migration[7.1]
  def change
    change_column :hole_details, :hole_id, :string
  end
end
