class UsersController < ApplicationController
  layout "sessions"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_and_remember @user
      redirect_to root_path, notice: "Check your email for confirmation instructions"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
