module Nil
  extend ActiveSupport::Concern

  def nil?
    true
  end

  def present?
    false
  end
end
