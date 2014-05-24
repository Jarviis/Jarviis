class Admin::UsersController < AdminController
  def index
    @users = User.includes(:teams).all
  end

  def edit
    @user = User.includes(:teams).find(params[:id])
  end

  def update
    @user_params = user_params

    if password_given?
      unless password_confirmation_match?
        flash[:error] = "Password did not match password confirmation"
        redirect_to :back and return
      end
    else
      @user_params.delete(:password)
      @user_params.delete(:password_confirmation)
    end

    @user = User.find(params[:id])
    @user.update_attributes(@user_params)

    redirect_to :back
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

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation,
                                 team_ids: [])
  end

  def password_given?
    user_params[:password].present?
  end

  def password_confirmation_match?
    user_params[:password] == user_params[:password_confirmation]
  end
end
