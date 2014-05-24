class AdminController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  layout "layouts/admin"
end
