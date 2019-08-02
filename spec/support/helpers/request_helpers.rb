module RequestHelpers
  def sign_in_as(user)
    post login_path, params: {session: {email: user.email, password: user.password}}
  end

  # テストユーザがログイン中の場合、trueを返す。
  def is_logged_in?
    !session[:user_id].nil?
  end
end
