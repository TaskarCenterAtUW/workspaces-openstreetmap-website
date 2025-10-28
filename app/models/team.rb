class Team < ApplicationRecord
# == Schema Information
#
# Table name: teams
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string           not null
#
# Indexes
#
#  teams_name_idx                    (name) UNIQUE
#
end
