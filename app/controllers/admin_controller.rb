class AdminController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
end
