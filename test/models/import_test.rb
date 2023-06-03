require "test_helper"

class ImportTest < ActiveSupport::TestCase
  class TestImport < Import
    attribute :source, default: :test
  end

  test "#start! sets started_at and finished_at" do
    now = Time.current
    import = TestImport.new
    import.start! {}
    assert_in_delta import.started_at, now, 0.5
    assert_in_delta import.finished_at, now, 0.5
  end

  test "#start! returns the instance" do
    import = TestImport.new
    import.start! {}
    assert_equal import, import.start! {}
  end
end
