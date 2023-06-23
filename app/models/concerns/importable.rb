module Importable
  extend ActiveSupport::Concern

  included do
    has_many :imports, foreign_key: :resource_id, dependent: :destroy
    has_many :import_fetches, foreign_key: :resource_id, dependent: :destroy, class_name: "Import::Fetch"
    has_one :recent_import, -> { order(started_at: :desc) }, class_name: "Import", foreign_key: :resource_id
    has_one :recent_successful_or_not_modified_import, -> { where(status: [:success, :not_modified]).order(started_at: :desc) }, class_name: "Import", foreign_key: :resource_id
  end

  def importing?
    recent_import.in_progress?
  end
end
