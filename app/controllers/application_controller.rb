class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include CountriesHelper
  include MatchesHelper
  include ApplicationHelper
  include UsersHelper
  include MessagesHelper
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
