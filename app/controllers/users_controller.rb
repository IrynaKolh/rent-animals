class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def activate
      @user = User.find(params[:id])
      if @user.update_column(:seller, true) # Skips validation
        redirect_to pets_path, notice: "User was successfully activated."
      else
        redirect_to root_path, alert: "User activation failed."
      end
    end    
    
  end
  