class Identity::PasswordResetsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_user, only: [:edit, :update]

  layout "forms"

  def new
  end

  def edit
  end

  def create
    if (@user = User.find_by(email: params[:email], verified: true))
      UserMailer.with(user: @user).password_reset.deliver_later
      redirect_to sign_in_path, notice: t(".success")
    else
      redirect_to new_identity_password_reset_path, alert: t(".failure")
    end
  end

  def update
    if @user.update(user_params)
      @token.destroy
      start_new_session_for @user
      redirect_to root_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @token = PasswordResetToken.find_signed!(params[:sid])
    @user = @token.user
  rescue
    redirect_to new_identity_password_reset_path, alert: t(".failure")
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
