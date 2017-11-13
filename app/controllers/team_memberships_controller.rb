class TeamMembershipsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @team_invitations = current_user.team_memberships.pending
    end

    def add
        invited_user = current_user.friends.find_by_email(params[:email])
        team = current_user.teams.find_by_id(params[:team_id])

        if invited_user && team
            invitation = invited_user.team_memberships.new(team: team)
            invitation.save
            redirect_to team_path(team)
        else 
            redirect_to authenticated_root_path
        end
    end

    def accept
        if invitation = current_user.team_memberships.find_by_id(params[:team_membership_id])
            invitation.accepted!
            redirect_to team_memberships_path
        else 
            redirect_to authenticated_root_path
        end
    end

    def destroy
        if invitation = current_user.team_memberships.find_by_id(params[:id])
            invitation.destroy!
            redirect_to team_memberships_path
        else 
            redirect_to authenticated_root_path
        end
    end
end
