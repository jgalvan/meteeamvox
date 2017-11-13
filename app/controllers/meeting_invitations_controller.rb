class MeetingInvitationsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @meeting_invitations = current_user.meeting_invitations.pending
    end

    def add
        invited_user = current_user.friends.find_by_email(params[:email])
        meeting = current_user.meeting_with_id(params[:meeting_id])

        if invited_user && meeting
            invitation = invited_user.meeting_invitations.new(meeting: meeting)
            invitation.save
            redirect_to meeting_path(meeting)
        else 
            redirect_to meeting_path(meeting)
        end
    end

    def accept
        if invitation = current_user.meeting_invitations.find_by_id(params[:meeting_invitation_id])
            invitation.accepted!
            redirect_to meeting_path(invitation.meeting)
        else 
            redirect_to meeting_invitations_path
        end
    end

    def destroy
        if invitation = current_user.meeting_invitations.find_by_id(params[:id])
            invitation.rejected!
            invitation.reason = params[:reason]
            invitation.save
            redirect_to meeting_invitations_path
        else 
            redirect_to meeting_invitations_path
        end
    end
end
