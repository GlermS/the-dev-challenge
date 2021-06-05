class SessionsController < ApplicationController
  def googleAuth
    info = request.env["omniauth.auth"].info
    user=User.find_or_create_by({email: info[:email], name: info[:name]})
    payload = {email: info[:email]}
    if user.valid?
      session[:auth_token]=JWT.encode payload, ENV['HMAC_SECRET'], ENV['HMAC_METHOD']
    end 
    redirect_to root_path
  end
  
  def signout
    session.delete :auth_token
    redirect_to root_path
  end
end
