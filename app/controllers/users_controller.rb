class UsersController < ApplicationController
    def show
        current_user.update_numbers
    end
end