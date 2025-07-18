class ImportExtraction < ApplicationRecord
  belongs_to :import
  belongs_to :extraction
end
