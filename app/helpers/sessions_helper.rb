module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && authenticated?(:remember, cookies[:remember_token])
        # セッションがないので、格納する
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザがログインユーザであれば、trueを返す
  def current_user?(user)
    user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # ユーザを永続的セッションに記憶する
  def remember(user)
    # 記憶トークンのDBの保存
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    # 記憶トークンをDBの破棄
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 記憶したURLまたはデフォルト値をにリダイレクトする
  # ログイン画面の遷移後、ユーザプロフィール画面を避けるため。
  def redirect_back_or(default)
    # defaultはroot_url
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # GETリクエストのURL情報を保持する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
