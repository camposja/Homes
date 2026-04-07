class ChangeFilesIdToString < ActiveRecord::Migration[7.1]
  def up
    # SQLite cannot ALTER column types or constraints in-place.
    # Recreate the table with a text primary key.
    create_table :files_new, id: false, force: true do |t|
      t.text :id, null: false, primary_key: true
      t.binary :content
      t.text :metadata
    end

    execute "INSERT INTO files_new (id, content, metadata) SELECT CAST(id AS TEXT), content, metadata FROM files;"
    drop_table :files
    rename_table :files_new, :files
  end

  def down
    create_table :files_new, id: :integer, force: true do |t|
      t.binary :content
      t.text :metadata
    end

    execute "INSERT INTO files_new (id, content, metadata) SELECT CAST(id AS INTEGER), content, metadata FROM files;"
    drop_table :files
    rename_table :files_new, :files
  end
end
