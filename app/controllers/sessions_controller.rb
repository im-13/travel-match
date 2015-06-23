class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.authenticate
  	if user
  		session[:user_id] = user.uuid
  		redirect_to @user, :notice => "Logged in!"
  	else
  		flash.now.alert = "Invalid email address or password"
  		render "new"
  	end
  end

  def destroy 
  	session[:user_id] = nil
  	redirect_to @user, :notice => "Logged out!"
  end

end
