class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def to_key
    key = (respond_to?(:hashid) && hashid) || (respond_to?(:id) && id)
    key ? [key] : nil
  end

  def self.saves_nested_attributes_for(name, with:)
    attr_accessor :"#{name}_attributes"

    define_method("autosave_associated_records_for_#{name}") do
      return if send("#{name}_attributes").blank?
      instance_exec(&with)
    end
  end
end
