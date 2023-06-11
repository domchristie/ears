require "test_helper"

class ImportTest < ActiveSupport::TestCase
  class TestImport < Import
    attribute :source, default: :test
  end

  class TestErrorImport < TestImport
    class Error < StandardError; end

    def start!
      super do
        raise Error # simulate exception
      end
    end
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

  test "#start sets finished_at in error cases" do
    import = TestErrorImport.new
    begin
      import.start!
    rescue TestErrorImport::Error
      assert import.finished_at
    end
  end
end
