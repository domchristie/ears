class ShowNotes
  def initialize(entry)
    @entry = entry
    @source = entry.content || entry.description
    externalize_links
    link_timestamps
  end

  def to_s
    doc.to_html.html_safe
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(
      Rails::Html::SafeListSanitizer.new.sanitize(@source)
    )
  end

  def links
    doc.search("//a")
  end

  def externalize_links
    links.each { |link| externalize_link(link) }
  end

  def externalize_link(link)
    link["target"] = "_blank"
    link["rel"] = "external noopener"
  end

  def link_timestamps
    unlinked_text_nodes = doc.search("//*[not(self::a or self::button or self::input or self::select or self::textarea) and not(ancestor::a or ancestor::button or ancestor::input or ancestor::select or ancestor::textarea)]/text()")
    unlinked_text_nodes.select do |node|
      Timestamp::REGEX.match?(node.content)
    end.each do |node|
      node.replace(create_linked_timestamps(node.content))
    end
  end

  def create_linked_timestamps(string)
    string.gsub(Timestamp::REGEX) do |match|
      render_timestamp(match)
    end
  end

  def render_timestamp(timestamp)
    ApplicationController.render(
      partial: EntryTimestamp.new(
        entry: @entry,
        timestamp: Timestamp.new(timestamp)
      )
    )
  end
end
