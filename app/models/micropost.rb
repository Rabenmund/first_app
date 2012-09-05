class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  MICROPOST_MAX_CHAR = 200

  validates :content, presence: true, length: { maximum: MICROPOST_MAX_CHAR }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  private

end