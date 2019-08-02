class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  # params[:email]
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # /password_resets/:id/edit?email=foo@bar.com
  def edit
  end

  # PATCH /password_resets == password_resets_path
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 自分のユーザのみ、パスワードの編集・更新を行う
  def valid_user
    if not (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  # トークンの有効期限切れチェック
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      resirect_to new_password_reset_url
    end
  end

  # Strong Parameter対策
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
