class SessionsController < ApplicationController
  # handle the post from the login page
  def create
    self.current_user = User.from_omniauth(request.env['omniauth.auth'])

    if current_user
      redirect_to root_path
    else
      redirect_to auth_path(provider: 'github')
    end
  end
end
