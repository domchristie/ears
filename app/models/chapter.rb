class Chapter < ApplicationRecord
  belongs_to :table_of_contents
  has_one :entry, through: :table_of_contents

  scope :ordered, -> { order(:start_time) }

  def self.attributes_for_import(remote_chapter)
    {
      start_time: remote_chapter[:startTime],
      title: remote_chapter[:title],
      image_url: remote_chapter[:img],
      url: remote_chapter[:url],
      toc: remote_chapter[:toc],
      end_time: remote_chapter[:endTime]
    }
  end

  def self.import_all!(table_of_contents_id, remote_chapters)
    attributes = remote_chapters.map do |remote_chapter|
      Chapter
        .attributes_for_import(remote_chapter)
        &.merge(table_of_contents_id: table_of_contents_id)
    end.compact

    Chapter.insert_all(attributes, record_timestamps: true)
  end
end
