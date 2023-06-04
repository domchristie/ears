module Importable
  extend ActiveSupport::Concern

  included do
    has_one :recent_successful_or_not_modified_import, -> { where(status: [:success, :not_modified]).order(started_at: :desc) }, class_name: "Import", foreign_key: :resource_id
  end
end
