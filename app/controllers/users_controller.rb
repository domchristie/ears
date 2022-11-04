class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy]
  layout "sessions"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email!
      login_and_remember @user
      redirect_to root_path, notice: "Check your email for confirmation instructions"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        if params[:user][:unconfirmed_email].present?
          @user.send_confirmation_email!
          redirect_to account_path, notice: "Check your email for confirmation instructions"
        else
          redirect_to account_path, notice: "Account updated"
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = "Incorrect password"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    logout
    redirect_to root_path, notice: "Account deleted"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
