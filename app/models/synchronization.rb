class Synchronization < ApplicationRecord
  belongs_to :fetch, dependent: :destroy
  belongs_to :resource, polymorphic: true

  private

  def log(message)
    Rails.logger.info "[#{self.class}] #{message}"
  end
end
