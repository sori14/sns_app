class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  before_save :downcase_email
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンをハッシュ化しDBに保存する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # attributeを使用し、汎用化する(動的ディスパッチ)
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    # if文 => cookiesの暴走問題
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # DBのremember_digestを破棄する
  def forget
    self.update_attribute(:remember_digest, nil)
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end

  # アカウントを有効化する
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワードの再設定
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード最設定の通知
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # reset_sent_atの時間を調べて、有効期限切れじゃないか調べる
  # true: 有効期限切れ | false: 有効期限内
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザのフィード（そのユーザのマイクロポストを全てを取得する）
  def feed
    # SQLインジェクション対策
    Micropost.where("user_id=?", self.id)
  end

  private

  # メールアドレスを全て小文字にする
  def downcase_email
    self.email = self.email.downcase
  end

end

