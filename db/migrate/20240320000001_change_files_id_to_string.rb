class ChangeFilesIdToString < ActiveRecord::Migration[7.1]
  def up
    # First, remove the primary key
    execute "ALTER TABLE files DROP CONSTRAINT files_pkey;"
    
    # Change the id column to text
    change_column :files, :id, :text
    
    # Add it back as primary key
    execute "ALTER TABLE files ADD PRIMARY KEY (id);"
  end

  def down
    # First, remove the primary key
    execute "ALTER TABLE files DROP CONSTRAINT files_pkey;"
    
    # Change the id column back to integer
    change_column :files, :id, :integer
    
    # Add it back as primary key
    execute "ALTER TABLE files ADD PRIMARY KEY (id);"
  end
end 