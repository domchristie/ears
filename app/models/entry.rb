class Entry < ApplicationRecord
  belongs_to :feed, touch: true
end
