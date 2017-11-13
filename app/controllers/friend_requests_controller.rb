class FriendRequestsController < ApplicationController
    before_action :authenticate_user!

    def index
        @friend_requests = current_user.friend_requests
    end

    def add
        if request = User.find_by_id(params[:id])
            current_user.pending_friends << request
            redirect_to user_search_path
        else 
            redirect_to user_search_path
        end
    end

    def accept
        if request = current_user.friend_requests.find_by_id(params[:friend_request_id])
            current_user.friends << request.user
            request.destroy
            redirect_to friend_requests_path
        else 
            redirect_to friend_requests_path
        end
    end

    def destroy
        if request = current_user.friend_requests.find_by_id(params[:id])
            request.destroy
            redirect_to friend_requests_path
        else 
            redirect_to friend_requests_path
        end
    end
end
