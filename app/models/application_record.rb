class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def to_key
    key = (respond_to?(:hashid) && hashid) || (respond_to?(:id) && id)
    key ? [key] : nil
  end
end
