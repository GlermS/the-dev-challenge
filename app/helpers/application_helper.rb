module ApplicationHelper
    def current_user
        @current_user ||= User.find_by(email: session[:user_email])
    end
    
    def logged_in?
        current_user
    end
end
