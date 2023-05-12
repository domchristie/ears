class Synchronization < ApplicationRecord
  has_many :fetches, dependent: :destroy
  belongs_to :resource, polymorphic: true

  private

  def log(message)
    Rails.logger.info "[#{self.class}] #{message}"
  end
end
