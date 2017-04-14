class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Assign the current user
  def current_user=(user)
    session[:user_id] = user.id
  end

end
