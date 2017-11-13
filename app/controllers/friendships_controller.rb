class FriendshipsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @friendships = current_user.friendships
    end

    def destroy
        if friendship = current_user.friendships.find_by_id(params[:id])
            friendship.destroy
            redirect_to friendships_path
        else 
            redirect_to friendships_path
        end
    end

    def search
        if params[:query]
            @search_results = User.search(params[:query]) - [current_user]
        end
    end
end
