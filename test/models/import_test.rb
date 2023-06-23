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

  test "#started? is false when not started" do
    assert_nil Import.new.started_at
    refute Import.new.started?
  end

  test "#started? is true when started" do
    import = Import.new(started_at: Time.current)
    assert import.started?
  end

  test "#finished? is false when not finished" do
    assert_nil Import.new.finished_at
    refute Import.new.finished?
  end

  test "#finished? is true when finished" do
    import = Import.new(started_at: Time.current, finished_at: Time.current)
    assert import.finished?
  end

  test "#in_progress is false when not started" do
    import = Import.new
    import.stub(:started?, false) do
      refute import.in_progress?
    end
  end

  test "#in_progress is false when finished" do
    import = Import.new
    import.stub(:finished?, true) do
      refute import.in_progress?
    end
  end

  test "#in_progress is true when started but not finished" do
    import = Import.new
    import.stub(:started?, true) do
      import.stub(:finished?, false) { assert import.in_progress? }
    end
  end
end
