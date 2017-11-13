class AddStatusToTeamMembership < ActiveRecord::Migration[5.1]
  def change
    add_column :team_memberships, :status, :int, default: 0
  end
end
