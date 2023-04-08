module ApplicationHelper
  def clink_to(title, link, css_class = nil)
    styled_title =
      css_class.nil? ? t(title) : raw("<i class=\"fa fa-fw #{css_class}\"></i>")
    link_to styled_title, link, title: title
  end

  def cdlink_to(title, link, icon = 'fa-remove', confirm_text = 'Вы действительно хотите удалить?')
    link_to icon.blank? ? t(title) : content_tag(:i, '', class: %i[fa fa-fw].push(icon)),
            link,
            title: title,
            method: :delete, data: { confirm: strip_tags( confirm_text) }
  end

  def num_to_usd(price)
    number_to_currency(price, unit: '')
  end

  def expenditure_color(expenditure)
    return expenditure.id unless expenditure.expenditure_type == 'на_товар'

    if expenditure.price == expenditure.total_paid
      color = 'yellow'
    elsif expenditure.price > expenditure.total_paid
      color = 'red'
    else
      color = 'green'
    end
    "<div style='color: #{color}'>#{expenditure.id}</div>".html_safe
  end
end
