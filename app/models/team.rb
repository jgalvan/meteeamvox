class Team < ApplicationRecord
    has_many :team_memberships
    has_many :users, through: :team_memberships

    has_many :meetings
end
