class Import < ApplicationRecord
  belongs_to :resource, polymorphic: true, optional: true
  belongs_to :synchronization, optional: true

  attr_accessor :data

  def self.start!(...)
    new(...).start!
  end

  def start!
    update!(started_at: Time.current)
    yield
    update!(finished_at: Time.current)
    self
  end
end
