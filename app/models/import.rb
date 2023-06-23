class Import < ApplicationRecord
  enum status: [:success, :not_modified, :not_found, :error]

  has_many :import_fetches, dependent: :destroy, class_name: "Import::Fetch"
  belongs_to :resource, polymorphic: true, optional: true

  def self.start!(...)
    new(...).start!
  end

  def start!
    update!(started_at: Time.current)
    yield
    self
  ensure
    update!(finished_at: Time.current)
  end

  def started?
    started_at.present?
  end

  def finished?
    finished_at.present?
  end

  def in_progress?
    started? && !finished?
  end

  private

  def log(message)
    Rails.logger.info "[#{self.class}] #{message}"
  end
end
