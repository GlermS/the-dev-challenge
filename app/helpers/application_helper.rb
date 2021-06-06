module ApplicationHelper
    def current_user
        begin
            payload = JWT.decode session[:auth_token], ENV['HMAC_SECRET'], true, {algorithm: ENV['HMAC_METHOD']}

            @current_user ||= User.find_by({email: payload[0]["email"]})
        rescue 
            ###
        end
    end
    
    def logged_in?
        current_user
    end
    
end
