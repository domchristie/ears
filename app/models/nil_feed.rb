class NilFeed < Feed
  include Nil

  def image_url
    "data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22 fill=%22white%22></svg>"
  end
end
