module ApplicationHelper

  def nav_link_to(label, path, link_args={})
    list_args = {}
    if current_page?(path)
      list_args[:class] = 'active'
      path = '#'
    end
    link = link_to(label, path, link_args)
    content_tag 'li', link, list_args
  end

end
