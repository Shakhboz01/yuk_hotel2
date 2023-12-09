module MainPageHelper
  def filter_income(income)
    return if income.created_at < 1.day.ago.end_of_day && income.total_paid >= income.price

    output = "<tr>
       #{expenditure_income_color(income, true)}
      <td>#{income.outcomer.name}</td>
      <td>#{num_to_usd(income.price) }</td>
      <td>#{num_to_usd(income.total_paid) }</td>"

    if income.total_paid < income.price
      output += "<td>#{clink_to "Пополнить оставщегося #{income.price - income.total_paid} сум", new_transaction_history_path(income_id: income.id), 'fa-money-bill-transfer' }</td>"
    end

    if income.transaction_histories.exists?
      output += "<td>#{clink_to 'история пополнений', transaction_histories_path(income_id: income.id), 'fa-clock-rotate-left' }</td>"
    end
    output += "<td>#{clink_to 'редактировать', edit_income_path(income), 'fa-edit' }</td>"
    output += "</tr>"
    output.html_safe
  end


  def filter_expenditure(expenditure)
    return if expenditure.created_at < 1.day.ago.end_of_day && expenditure.total_paid >= expenditure.price

    output = "<tr>
      #{expenditure_income_color(expenditure)}
      <td>#{expenditure.expenditure_type}</td>
      <td>#{num_to_usd(expenditure.price)}</td>"

    if expenditure.expenditure_type == 'на_товар'
      output += "<td>#{num_to_usd(expenditure&.total_paid)}</td>
                 <td>#{expenditure&.outcomer&.name}</td>
                 <td>#{expenditure&.quantity}</td>"
    end

    if expenditure.total_paid < expenditure.price && expenditure.expenditure_type == 'на_товар'
      output += "
        <td>#{clink_to "Пополнить оставщегося #{expenditure.price - expenditure.total_paid} сум", new_transaction_history_path(expenditure_id: expenditure.id), 'fa-money-bill-transfer'}</td>"
    end

    if expenditure.transaction_histories.exists?
      output += "<td colspan='6'>#{clink_to 'история пополнений', transaction_histories_path(expenditure_id: expenditure.id), 'fa-clock-rotate-left'}</td>"
    end
    output += "<td>#{clink_to('редактировать', edit_expenditure_path(expenditure), 'fa-edit')}</td>"
    output += "</tr>"

    output.html_safe
  end

  def find_debetors(outcomer)
    case outcomer.role
    when 'покупатель'
      difference = outcomer.incomes.sum(:total_paid) - outcomer.incomes.sum(:price)

      return if difference >= 0

      "<td>#{outcomer.name}</td>
       <td class='debet'>#{num_to_usd(difference.abs)}</td>".html_safe
    when 'поставщик'
      difference = outcomer.expenditures.sum(:total_paid) - outcomer.expenditures.sum(:price)

      return if difference <= 0

      "<td> #{outcomer.name} </td>
       <td class='debet'> #{num_to_usd(difference.abs)}</td>".html_safe
    end
  end

  def find_creditors(outcomer)
    case outcomer.role
    when 'покупатель'
      difference = outcomer.incomes.sum(:total_paid) - outcomer.incomes.sum(:price)

      return if difference <= 0

      "<td>#{outcomer.name}</td>
       <td class='amount'>#{num_to_usd(difference.abs)}</td>".html_safe
    when 'поставщик'
      difference = outcomer.expenditures.sum(:total_paid) - outcomer.expenditures.sum(:price)

      return if difference >= 0

      "<td> #{outcomer.name} </td>
       <td class='amount'> #{num_to_usd(difference.abs)}</td>".html_safe
    end
  end
end
