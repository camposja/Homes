class SessionController < ApplicationController
  # logging in
  def new
  end

  # handle the post from the login page
  def create
    self.current_user = User.from_omniauth(request.env['omniauth.auth'])

    if current_user
      # Send the email notifying the user!
      NotificationsMailer.signup(@user).deliver_later
      # byebug
      redirect_to request.referer
    else
      redirect_to auth_path(provider: 'github')
    end
  end

  # logout
  def destroy
    session[:user_id] = nil
    redirect_to homes_path
  end

  # Show the failure page
  def failure
  # TODO, create failure.html.erb
  end
end
