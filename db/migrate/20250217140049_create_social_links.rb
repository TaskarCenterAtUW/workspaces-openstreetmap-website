class CreateSocialLinks < ActiveRecord::Migration[7.2]
  def change
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    create_table :social_links do |t|
      t.references :user, :null => false, :foreign_key => true
      t.string :url, :null => false

      t.timestamps
    end
  end
end
