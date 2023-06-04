class Import::Transform
  def self.data(...)
    new(...).data
  end

  def initialize(source)
    @source = source
  end
end
