class ApplicationController < ActionController::Base
  include ApplicationHelper
    def check_login
        @current_user=logged_in?
    end
end
