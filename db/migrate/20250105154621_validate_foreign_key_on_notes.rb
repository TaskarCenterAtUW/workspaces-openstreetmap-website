class ValidateForeignKeyOnNotes < ActiveRecord::Migration[7.2]
  def change
    validate_foreign_key :notes, "public.users"
  end
end
