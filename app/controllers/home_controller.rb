class HomeController < ApplicationController
   
    
    def to_user_show
        redirect_to user_path(current_user)
    end
end
