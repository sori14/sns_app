class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :replies, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :retweet_users, through: :retweets, source: :user


  # 検索機能
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end

  #　マイクロポストをいいねする
  def like(user)
    likes.create(user_id: user.id)
  end

  # マイクロポストのいいねを解除する
  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  # 現在のユーザがいいねしてたら、trueを返す
  def like?(user)
    like_users.include?(user)
  end

  # マイクロポストにコメントする
  def reply(user, content)
    replies.create(user_id: user.id, content: content)
  end

  # マイクロポストをリツイートする
  def retweet(user)
    retweets.create(user_id: user.id)
  end

  # 現在のユーザがリツイートしてたら、trueを返す
  def retweet?(user)
    self.retweet_users.include?(user)
  end

  private

  # アップロードされた画像のバリデーション
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less 5MB")
    end
  end
end
