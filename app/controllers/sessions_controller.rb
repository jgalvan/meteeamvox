class SessionsController < Devise::SessionsController  
    #clear_respond_to
    layout false
    respond_to :json
end