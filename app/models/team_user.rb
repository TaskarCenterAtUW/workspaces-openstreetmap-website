# == Schema Information
#
# Table name: team_user
#
#  team_id    :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null, primary key
#
# Indexes
#
#  team_id_user_id_unique  (team_id,user_id) UNIQUE
#
# Foreign Keys
#
#  team_id_fkey  (team_id => teams.id)
#  user_id_fkey  (user_id => users.id)
#
class TeamUser < ApplicationRecord
    belongs_to :team
    belongs_to :user
end
