class SearchResult
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title
  attribute :image_url
  attribute :details
  attribute :meta
  attribute :path

  def to_partial_path
    "search_results/search_result"
  end
end
