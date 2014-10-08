class User < ActiveRecord::Base
  has_many :videos, foreign_key: "author_id"
  has_many :playlists

  validates :email, presence: true, uniqueness: true
end
