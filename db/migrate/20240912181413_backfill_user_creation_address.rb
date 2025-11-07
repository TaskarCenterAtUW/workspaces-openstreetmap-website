class BackfillUserCreationAddress < ActiveRecord::Migration[7.1]
  class User < ApplicationRecord
  end

  def up
    if connection.current_schema.start_with?("workspace-")
      return # Ignore this migration in workspace tenant schemas
    end

    User
      .where(:creation_address => nil)
      .where.not(:creation_ip => nil)
      .in_batches(:of => 1000)
      .update_all("creation_address = creation_ip::inet")
  end

  def down; end
end
