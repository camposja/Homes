class CreateFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :files do |t|
      t.binary :content
      t.text :metadata
    end
  end
end
