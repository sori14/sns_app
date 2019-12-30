class Relationship < ApplicationRecord
  # フォローしているユーザ
  belongs_to :follower, class_name: 'User'
  # フォローされているユーザ
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
