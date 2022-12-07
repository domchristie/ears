class PlaylistItem < ApplicationRecord
  include Hashid::Rails
  belongs_to :playlist
  belongs_to :entry
end
