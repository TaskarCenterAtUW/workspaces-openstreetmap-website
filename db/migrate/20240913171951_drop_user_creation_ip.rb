class DropUserCreationIp < ActiveRecord::Migration[7.1]
  def change
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    safety_assured { remove_column :users, :creation_ip, :string }
  end
end
