module ApplicationHelper
    def current_user
        begin
            puts session[:auth_token]
            payload = JWT.decode session[:auth_token], ENV['HMAC_SECRET'], false, {algorithm: ENV['HMAC_METHOD']}

            @current_user ||= User.find_by({email: payload[0]["email"]})
        rescue 
            puts "Invalid token"
        end
    end
    
    def logged_in?
        current_user
    end
    
end
