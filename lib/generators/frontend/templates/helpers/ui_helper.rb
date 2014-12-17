module UiHelper
  def font_awesome(name, options = '')
    content_tag(:span, '', class: "fa fa-#{name} #{options}".strip)
  end

  def link_to_delete(url, title='delete', options = {}, &block)
    options.merge!(method: :delete, data: { confirm: 'Are you sure you want to delete this?' })

    link_to url, options do
      block_given? ? yield : title
    end
  end
end
