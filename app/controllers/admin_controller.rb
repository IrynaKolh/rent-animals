class AdminController < ApplicationController
    before_action :check_admin_priv
    def show
    end
    private
    def check_admin_priv
      unless current_admin
        flash[:alert] = "You do not have permission to access this page."
        redirect_to root_path
      end
    end
end