class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  	if @current_user
  		puts "current_user found" 
  	end 
  end

  def email_uniqueness(email)
    user = User.find_by(email: email)
    if user
      self.errors.add(:email, "Email belongs to an existing account.")
    else
      nil
    end
  end


end
