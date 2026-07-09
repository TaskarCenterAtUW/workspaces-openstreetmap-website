class AddCompanyToUsers < ActiveRecord::Migration[8.0]
  def change
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    add_column :users, :company, :string
  end
end
