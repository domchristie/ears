class Feed < ApplicationRecord
  has_many :entries, dependent: :destroy
end
