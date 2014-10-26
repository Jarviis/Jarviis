class DashboardController < ApplicationController
  def index
    if current_user
      cookies[:token] = current_user.authentication_token
    end
  end
end
