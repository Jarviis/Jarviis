class AdminController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  before_action :authorize!
  layout "layouts/admin"

  private

  def permission
    @permission ||= Permission.new(current_user)
  end

  def authorize!
    if !permission.allow?
      redirect_to root_url, alert: "Not authorized"
    end
  end
end
