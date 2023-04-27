class Synchronization < ApplicationRecord
  belongs_to :fetch, dependent: :destroy

  private

  def log(message)
    puts "[#{self.class}] #{message}"
  end
end
