class Import::Transform
  def self.data(...)
    new(...).data
  end

  def initialize(source, resource: nil)
    @source = source
    @resource = resource
  end
end
