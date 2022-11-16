class Identity::EmailsController < ApplicationController
  before_action :authenticate

  layout "forms"

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update(user_params)
      redirect_to_root
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email)
  end

  def redirect_to_root
    if @user.email_previously_changed?
      resend_email_verification
      redirect_to root_path, notice: "Email updated"
    else
      redirect_to root_path
    end
  end

  def resend_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
