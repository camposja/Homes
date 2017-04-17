class AddCreatedByToHomes < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :created_by_id, :integer
  end
end
