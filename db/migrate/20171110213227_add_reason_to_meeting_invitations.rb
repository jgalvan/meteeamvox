class AddReasonToMeetingInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :meeting_invitations, :reason, :string
  end
end
