class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include CountriesHelper
  include MatchesHelper
  include ApplicationHelper
  include UsersHelper

  private 
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

=begin
  private


  def email_uniqueness(email)
    user = User.find_by(email: email)
    if user
      self.errors.add(:email, "Email belongs to an existing account.")
    else
      nil
    end
  end
=end

end
