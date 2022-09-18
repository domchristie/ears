class NilPlay < Play
  include Nil

  def entry
    NilEntry.new
  end

  def elapsed
    0
  end

  def remaining
    0
  end

  def progress
    0
  end
end
