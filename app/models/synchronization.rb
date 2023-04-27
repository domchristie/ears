class Synchronization < ApplicationRecord
  belongs_to :fetch

  private

  def log(message)
    puts "[#{self.class}] #{message}"
  end
end
