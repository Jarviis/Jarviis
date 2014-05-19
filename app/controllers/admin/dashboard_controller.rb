class Admin::DashboardController < AdminController
  def index
    @issues_count = Issue.count
    @users_count  = User.count
  end
end
