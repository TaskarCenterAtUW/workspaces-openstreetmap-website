class AddUserCreationAddress < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    add_column :users, :creation_address, :inet
    add_index :users, :creation_address, :using => :gist, :opclass => :inet_ops, :algorithm => :concurrently
  end
end
