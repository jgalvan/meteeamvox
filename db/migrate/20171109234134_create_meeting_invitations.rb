class CreateMeetingInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :meeting_invitations do |t|
      t.references :meeting, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
