require "test_helper"

class ImportTest < ActiveSupport::TestCase
  class TestImport < Import
    attribute :source, default: :test

    def extract
      Extraction.create!(resource:, result: {body: "test"}, status: :success)
    end

    def transform
      extraction.result[:body]
    end

    def load(data)
    end
  end

  class TestErrorImport < TestImport
    class Error < StandardError; end

    def start
      super do
        raise Error # simulate exception
      end
    end
  end

  test "#start sets started_at and finished_at" do
    now = Time.current
    import = TestImport.new(resource: feeds(:one))
    import.start
    assert_in_delta import.started_at, now, 0.5
    assert_in_delta import.finished_at, now, 0.5
  end

  test "#start returns the instance" do
    import = TestImport.new(resource: feeds(:one))
    assert_equal import, import.start
  end

  test "#start sets finished_at in error cases" do
    import = TestErrorImport.new(resource: feeds(:one))
    begin
      import.start
    rescue TestErrorImport::Error
      assert import.error?
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

  test "#start calls extract, transform, and load for a successful import" do
    extraction = extractions(:success)

    mock = Minitest::Mock.new
    mock.expect :extract, extraction
    mock.expect :transform, :transformed_data
    mock.expect :load, nil, [:transformed_data]

    import = TestImport.new(resource: feeds(:one))
    import.define_singleton_method(:extract) { mock.extract }
    import.define_singleton_method(:transform) { mock.transform }
    import.define_singleton_method(:load) { |data| mock.load(data) }

    import.start
    mock.verify
  end

  test "#start does not call extract if an extraction already exists" do
    mock = Minitest::Mock.new
    import = TestImport.new(
      resource: feeds(:one), extraction: extractions(:success)
    )
    import.define_singleton_method(:extract) { mock.extract }

    import.start
    mock.verify
  end

  test "#start does not call transform if the extraction is not successful" do
    mock = Minitest::Mock.new
    import = TestImport.new(
      resource: feeds(:one), extraction: extractions(:not_modified)
    )
    import.define_singleton_method(:transform) { mock.transform }

    import.start
    mock.verify
  end

  test "#start does not call load if the extraction is not successful" do
    mock = Minitest::Mock.new
    import = TestImport.new(
      resource: feeds(:one), extraction: extractions(:not_modified)
    )
    import.define_singleton_method(:load) { mock.load }

    import.start
    mock.verify
  end

  test "#start creates an ImportExtraction" do
    existing_ids = ImportExtraction.pluck(:id)
    assert_difference -> { ImportExtraction.where.not(id: existing_ids).count } do
      TestImport.new(resource: feeds(:one)).start
    end
  end

  test "#start creates an ImportExtraction when an extraction already exists" do
    existing_ids = ImportExtraction.pluck(:id)
    assert_difference -> { ImportExtraction.where.not(id: existing_ids).count } do
      TestImport.new(
        resource: feeds(:one), extraction: extractions(:success)
      ).start
    end
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
