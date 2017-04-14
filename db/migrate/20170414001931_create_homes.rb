class CreateHomes < ActiveRecord::Migration[5.0]
  def change
    create_table :homes do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :bedrooms
      t.integer :baths
      t.integer :square_feet
      t.integer :price
      t.string :description
      t.text :image_data

      t.timestamps
    end
  end
end
