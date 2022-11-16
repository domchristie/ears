class Identity::EmailVerificationsController < ApplicationController
  before_action :authenticate, only: :create
  before_action :set_user, only: :edit

  def edit
    @user.update! verified: true
    redirect_to root_path, notice: "Email confirmed"
  end

  def create
    UserMailer.with(user: Current.user).email_verification.deliver_later
    redirect_to root_path, notice: "Email verification sent"
  end

  private

  def set_user
    @token = EmailVerificationToken.find_signed!(params[:sid])
    @user = @token.user
  rescue
    redirect_to edit_identity_email_path, alert: "Invalid verification link"
  end
end
