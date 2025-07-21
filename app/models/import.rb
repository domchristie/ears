class Import < ApplicationRecord
  enum :status, [:success, :not_modified, :not_found, :error]

  belongs_to :resource, polymorphic: true
  has_one :import_extraction, dependent: :destroy
  has_one :extraction, through: :import_extraction

  after_save_commit :clean_up, if: :finished?

  def self.start(...) = new(...).start

  def start
    update!(started_at: Time.current)

    begin
      update!(extraction: extract) unless extraction
      load(transform) if extraction.success?
      update!(status: extraction.status)
    rescue
      error!
      raise
    ensure
      update!(finished_at: Time.current)
    end

    self
  end

  def started? = started_at.present?

  def finished? = finished_at.present?

  def in_progress? = started? && !finished?

  def self.reprocess(import)
    import.class.start(
      resource: import.resource,
      extraction: import.extraction
    )
  end

  private

  def clean_up
    if success?
      resource.imports.where(created_at: ...created_at)
    else
      resource.imports
        .where(created_at: ...created_at)
        .where.not(status: :success)
    end.destroy_all
  end
end
