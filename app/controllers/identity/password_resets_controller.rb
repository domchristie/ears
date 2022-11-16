class Identity::PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  layout "forms"

  def new
  end

  def edit
  end

  def create
    if (@user = User.find_by(email: params[:email], verified: true))
      UserMailer.with(user: @user).password_reset.deliver_later
      redirect_to sign_in_path, notice: "Check your email for instructions"
    else
      redirect_to new_identity_password_reset_path, alert: "Email verification required"
    end
  end

  def update
    if @user.update(user_params)
      @token.destroy
      sign_in @user
      redirect_to root_path, notice: "Password updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @token = PasswordResetToken.find_signed!(params[:sid])
    @user = @token.user
  rescue
    redirect_to new_identity_password_reset_path, alert: "Invalid password reset link"
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
