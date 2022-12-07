class Playlist < ApplicationRecord
  include Hashid::Rails
  belongs_to :user
  has_many :playlist_items, dependent: :destroy
end
