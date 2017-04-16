class AddImageDataToHomes < ActiveRecord::Migration[5.0]
  def change
    add_column :homes, :image_data, :text
  end
end
