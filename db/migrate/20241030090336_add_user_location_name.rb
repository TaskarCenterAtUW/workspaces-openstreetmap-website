class AddUserLocationName < ActiveRecord::Migration[7.2]
  def change
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    add_column :users, :home_location_name, :string
  end
end
