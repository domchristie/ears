class Playlist < ApplicationRecord
  include Hashid::Rails
  belongs_to :user
  has_many :items, class_name: "PlaylistItem", dependent: :destroy
  has_many :entries, through: :items

  def prepend_entry(entry)
    items.create(entry:)
  end
end
