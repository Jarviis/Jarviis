class Admin::UsersController < AdminController
  def index
    @users = User.includes(:teams).all
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = "#{@user.username} user was successfuly destroyed."
      forensic = Forensic.new
      forensic.user_id = current_user.id
      forensic.description = @user.to_json
      forensic.action = Forensic::ACTIONS[:destroy_user]
      forensic.save
    else
      flash[:error] = "Something went wrong while destroying user #{@user.username}"
    end

    redirect_to :back
  end
end
