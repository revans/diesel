module BootstrapHelper
  def glyphicon(icon_type)
    content_tag(:span, '', class: "glyphicon glyphicon-#{icon_type}")
  end

  def bootstrap_label(content, label_type = 'default')
    content_tag(:span, content, class: "label label-#{label_type}")
  end

  def bootstrap_h1_page_title(content, klass='', &block)
    content_tag(:div, class: 'page-header') do
      if block_given?
        content_tag(:h1, title, class: klass) + yield
      else
        content_tag(:h1, title, class: klass)
      end
    end
  end

  def link_to_icon(url, icon_type)
    link_to url do
      glyphicon(icon_type)
    end.html_safe
  end

  def delete_with_trash_icon(url)
    link_to url, method: :delete, data: { confirm: 'Are you sure you want to delete this?' }, remote: true do
      glyphicon("trash")
    end.html_safe
  end
end
