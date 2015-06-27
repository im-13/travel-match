class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.authenticate(params[:session][:email].downcase, params[:session][:password])
  	if user
  		log_in user
  		redirect_to user
  	else
  		flash.now[:danger] = 'Invalid email address or password'
  		render 'new'
  	end
  end

  def destroy
  	log_out
    redirect_to root_url
  end

end
