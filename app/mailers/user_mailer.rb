class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
    # mail objectの中身の説明
    # app/views/user_mailer/account_activation.text.erb
    # app/views/user_mailer/account_activation.html.erb
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
    # mail objectの中身の説明
    # app/views/user_mailer/password_reset.text.erb
    # app/views/user_mailer/password.html.erb
  end
end
