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
    number_to_currency(price)
  end

  def expenditure_color(expenditure)
    unless expenditure.expenditure_type == 'на_товар'
      return "<td>#{expenditure.id}</td>".html_safe
    end

    if expenditure.price == expenditure.total_paid
      color = 'bg-warning'
    elsif expenditure.price > expenditure.total_paid
      color = 'bg-danger'
    else
      color = 'bg-success'
    end
    "<td class='#{color}'>#{expenditure.id}</td>".html_safe
  end

  def calculate_difference(outcomer)
    class_name = ''
    difference=0

    if outcomer.role == 'поставщик'
      expenditures = outcomer.expenditures


      difference = expenditures.sum(:total_paid) - expenditures.на_товар.sum(:price)

      if difference == 0
        class_name = 'bg-warning'
      elsif difference < 0
        class_name = 'bg-danger'
      else
        class_name = 'bg-success'
      end
    end

      "<td class='#{class_name}'>#{outcomer.id}</td> \n
      <td>#{num_to_usd(difference)}</td>
      ".html_safe
  end

  def calculate_expenditure_diff(amount)
    if amount == 0
      style = 'text-warning'
    elsif amount < 0
      style = 'text-success'
    elsif amount > 0
      style = 'text-danger'
    end
    "<strong class='#{style}'>#{num_to_usd(amount)}</strong>".html_safe
  end
end
