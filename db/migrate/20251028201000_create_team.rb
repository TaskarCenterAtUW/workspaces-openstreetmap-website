class CreateTeam < ActiveRecord::Migration[7.1]
  def up
    create_table :teams, primary_key: :id do |t|
      t.integer :id
      t.integer :workspace_id
      t.string :name
    end

    add_index :teams, [:name, :workspace_id], unique: true
    add_index :teams, :workspace_id

    create_table :team_user do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false
    end

    add_index :team_user, [:team_id, :user_id], unique: true
    add_foreign_key :team_user, :teams, column: :team_id
    add_foreign_key :team_user, :users, column: :user_id
  end
  
  def down
    drop_table :team_user
    drop_table :teams
  end
end
