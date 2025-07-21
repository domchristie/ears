module Importable
  extend ActiveSupport::Concern

  included do
    has_many :imports, foreign_key: :resource_id, dependent: :destroy
    has_one :recent_import, -> { order(started_at: :desc) }, class_name: "Import", foreign_key: :resource_id
    has_many :extractions, foreign_key: :resource_id, dependent: :destroy
  end

  def importing?
    recent_import.in_progress?
  end
end
