class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # user => emailの間違いでuserがnilの可能性がある
    # !user.activated? => URLを２回クリックする可能性を拒否する
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "invalid activation link"
      redirect_to root_url
    end
  end
end
