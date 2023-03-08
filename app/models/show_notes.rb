class ShowNotes
  include ActionView::Helpers

  def initialize(entry)
    @entry = entry
    @source = entry.content || entry.description
    remove_empty_ps
    externalize_links
    link_timestamps
  end

  def to_s
    doc.css("body").inner_html.html_safe
  end

  private

  def source_html?
    sanitize(@source) != strip_tags(@source)
  end

  def source_html
    # auto_link and simple_format both sanitize by default
    if source_html?
      auto_link(@source)
    else
      simple_format(auto_link(@source, sanitize: false))
    end
  end

  def doc
    @doc ||= Nokogiri::HTML.parse(source_html)
  end

  def remove_empty_ps
    doc.xpath("//p[not(normalize-space())]").each(&:remove)
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
    unlinked_text_nodes = doc.xpath("//*[not(self::a or self::button or self::input or self::select or self::textarea) and not(ancestor::a or ancestor::button or ancestor::input or ancestor::select or ancestor::textarea)]/text()")
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
    ).strip
  end
end
