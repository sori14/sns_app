class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :content, presence: true, length: {minimum: 1, maximum: 1000}
end
