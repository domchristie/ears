class UserMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    @signed_id = @user.password_reset_tokens.create.signed_id(
      expires_in: PasswordResetToken::VALIDITY_DURATION
    )
    mail to: @user.email, subject: "Reset your password"
  end

  def email_verification
    @user = params[:user]
    @signed_id = @user.email_verification_tokens.create.signed_id(
      expires_in: EmailVerificationToken::VALIDITY_DURATION
    )
    mail to: @user.email, subject: "Verify your email"
  end
end
