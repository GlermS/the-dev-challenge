class SessionsController < ApplicationController
  def googleAuth
    info = request.env["omniauth.auth"].info
    user=User.find_or_create_by({email: info[:email], name: info[:name]})
    if user.valid?
      session[:user_email]=info[:email]
    end 
    puts info
    redirect_to root_path
  end
  
  def signout
    session.delete :user_email
    redirect_to root_path
  end
end
