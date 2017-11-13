Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticated :user do
    root 'meetings#index', as: :authenticated_root
  end
  
  unauthenticated :user do
    root 'home#index', as: :unauthenticated_root
    get '/about_us', to: 'home#about_us'
    get '/how_it_works', to: 'home#how_it_works'
    get '/try_it_out', to: 'home#try_it_out'
    post :upload_audio, to: 'meetings#upload_audio'
  end

  authenticate :user do
    resources :meetings do
      post :upload_audio, on: :collection
      post :add_team, on: :member
      resources :meeting_invitations, only: [] do
        post :add, on: :collection
      end
    end
    resources :friendships, only: [:index, :destroy]
    resources :friend_requests, only: [:index, :destroy]  do 
      post :accept
      post :add, on: :member
    end
    resources :meeting_invitations, only: [:index, :destroy]  do 
      post :accept
    end

    resources :team_memberships, only: [:index, :destroy]  do 
      post :accept
    end

    get '/users/search', to: 'friendships#search', as: 'user_search'

    resources :teams do
      resources :meetings, only: [:new, :create]
      resources :team_memberships, only: [] do
        post :add, on: :collection
      end
    end
  end
  
end
