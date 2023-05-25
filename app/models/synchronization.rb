class Synchronization < ApplicationRecord
  has_many :fetches, dependent: :destroy
  belongs_to :resource, polymorphic: true

  def self.start!(...)
    new(...).start!
  end

  def start!
    update!(started_at: Time.current)
    yield
    update!(finished_at: Time.current)
    self
  end

  private

  def log(message)
    Rails.logger.info "[#{self.class}] #{message}"
  end
end
