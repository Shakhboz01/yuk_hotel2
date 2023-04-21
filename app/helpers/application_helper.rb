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
    difference = 0

    if outcomer.role == 'поставщик'
      expenditures = outcomer.expenditures

      difference = expenditures.sum(:total_paid) - expenditures.sum(:price)

      if difference == 0
        class_name = 'bg-warning'
      elsif difference < 0
        class_name = 'bg-danger'
      else
        class_name = 'bg-success'
      end
    else
      incomes = outcomer.incomes

      difference = incomes.sum(:total_paid) - incomes.sum(:price)

      if difference == 0
        class_name = 'bg-warning'
      elsif difference < 0
        class_name = 'bg-success'
      else
        class_name = 'bg-danger'
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

  def handle_product_bg_color(product_id)
    case product_id
    when 1
      '#c2b280'
    when 2
      'grey'
    else
      'white'
    end
  end

  def calculate_sausage_expected_result(sausage)
    quantity = sausage.quantity * sausage.machine_size.devision
    ((quantity - (quantity * 0.02)).to_f / 6).to_i
  end

  def calculate_operators_monthly_payment(operator)
    sausage_price = 2000
    actual_quantity = operator.machine_size.devision * operator.sausages.created_this_month.sum(:quantity)
    actual_quantity * sausage_price
  end

  def difference_in_percentage(first_value, second_value)
    difference = second_value.to_f / first_value.to_f - 1
    difference_percent = difference * 100
    color_class = difference_percent < -2 ? 'text-danger' : ''

    content_tag(:span, class: color_class) do
      "#{difference_percent.round(1)}%"
    end
  end
end
