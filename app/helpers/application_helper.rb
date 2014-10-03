module ApplicationHelper
  def set_css(*sources)
    content_for(:css, sources.join(",") + ",")
  end

  def set_javascript(*sources)
    content_for(:javascript, sources.join(",") + ",")
  end

  def page_css
    if content_for?(:css)
      sources = content_for(:css).chomp(",").split(",")
      stylesheet_link_tag *sources
    end
  end

  def page_javascript
    if content_for?(:javascript)
      sources = content_for(:javascript).chomp(",").split(",")
      javascript_include_tag *sources
    end
  end
end
