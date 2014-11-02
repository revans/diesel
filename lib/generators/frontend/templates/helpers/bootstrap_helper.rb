module BootstrapHelper
  def glyphicon(icon_type)
    content_tag(:span, '', class: "glyphicon glyphicon-#{icon_type}")
  end

  def font_awesome(name, options = '')
    content_tag(:span, '', class: "fa fa-#{name} #{options}".strip)
  end

  def bootstrap_label(content, label_type = 'default')
    content_tag(:span, content, class: "label label-#{label_type}")
  end

  def bootstrap_page_title(title, klass='', &block)
    content_tag(:div, class: 'page-header') do
      if block_given?
        content_tag(:h1, title, class: klass) + yield
      else
        content_tag(:h1, title, class: klass)
      end
    end
  end


  def link_to_delete(url, title='delete', options = {}, &block)
    options.merge!(method: :delete, data: { confirm: 'Are you sure you want to delete this?' })

    link_to url, options do
      block_given? ? yield : title
    end
  end
end
