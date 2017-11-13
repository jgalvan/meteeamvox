class TeamsController < ApplicationController
    before_action :authenticate_user!
  
    def show
        @team = current_user.teams.find_by_id( params[:id])

        if @team.nil?
            redirect_to meetings_path
        else

            @members = @team.users

            @meetings = @team.meetings

            if params[:query]
                query = params[:query]

                @meetings = @meetings.where("title LIKE :query", query: "%#{query}%") 
            end
        end
        
    end

    def index
        @teams = current_user.teams

        @meeting = current_user.meeting_with_id(params[:id])
    end

    def destroy
        if team = current_user.teams.find_by_id(params[:id])
            team.team_memberships.find_by_user_id(current_user.id).destroy

            if team.users.count == 0
                team.destroy
            end

            redirect_to authenticated_root_path
        else 
            redirect_to authenticated_root_path
        end
    end

    def create
        team =Team.new(team_name: params[:team_name])
        team.save!

        team_membership = TeamMembership.new(team: team, user: current_user, status: "accepted")
        team_membership.save!

        puts("HEII")

        redirect_to team_path(team)
        
    end

end
