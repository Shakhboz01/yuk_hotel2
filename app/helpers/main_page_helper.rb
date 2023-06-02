module MainPageHelper
  def filter_income(income)
    return if income.created_at < 1.day.ago.end_of_day && income.total_paid >= income.price

    "<tr>
       #{expenditure_income_color(income, true)}
      <td>#{income.outcomer.name}</td>
      <td>#{num_to_usd(income.price) }</td>
      <td>#{num_to_usd(income.total_paid) }</td>
      <td>#{clink_to 'редактировать', edit_income_path(income), 'fa-edit' }</td>
    </tr>".html_safe
  end

  def filter_expenditure(expenditure)
    return if expenditure.created_at < 1.day.ago.end_of_day && expenditure.total_paid >= expenditure.price

    "<tr>
      #{expenditure_income_color(expenditure)}
      <td>#{expenditure.expenditure_type}</td>
      <td>#{num_to_usd(expenditure.price)}</td>
      <td>#{expenditure.expenditure_type == 'на_товар' ? num_to_usd(expenditure&.total_paid) : ''}</td>
      <td>#{expenditure&.outcomer&.name}</td>
      <td>#{expenditure&.quantity}</td>
      #{if expenditure.expenditure_type == 'на_товар'
         "<td>#{clink_to('редактировать', edit_expenditure_path(expenditure), 'fa-edit')}</td>"
       end}
    </tr>".html_safe
  end

  def find_debetors(outcomer)
    case outcomer.role
    when 'покупатель'
      difference = outcomer.incomes.sum(:total_paid) - outcomer.incomes.sum(:price)

      return if difference >= 0

      "<td>#{outcomer.name}</td>
       <td>#{num_to_usd(difference.abs)}</td>".html_safe
    when 'поставщик'
      difference = outcomer.expenditures.sum(:total_paid) - outcomer.expenditures.sum(:price)

      return if difference <= 0

      "<td> #{outcomer.name} </td>
       <td> #{num_to_usd(difference.abs)}</td>".html_safe
    end
  end

  def find_creditors(outcomer)
    case outcomer.role
    when 'покупатель'
      difference = outcomer.incomes.sum(:total_paid) - outcomer.incomes.sum(:price)

      return if difference <= 0

      "<td>#{outcomer.name}</td>
       <td>#{num_to_usd(difference.abs)}</td>".html_safe
    when 'поставщик'
      difference = outcomer.expenditures.sum(:total_paid) - outcomer.expenditures.sum(:price)

      return if difference >= 0

      "<td> #{outcomer.name} </td>
       <td> #{num_to_usd(difference.abs)}</td>".html_safe
    end
  end
end
