product_names = [
  ['Картон', 0],
  ['Серый',0],
  ['Белый', 0],
  ['Целлофан', 1],
  ['Этикетка', 2],
  ['Rolli', 3],
  ['Ишонч', 3],
  ['Без этикетка Rolli', 3],
]

product_names.each do |product|
  Product.create(name: product[0], amount_left: 0, weight: product[1])
end

# Product.find_by(weight: 1).product_prices.create(price: ) # find price here

3.times do
  WastePaperProportion.create
end

paper_details = [[50, 'Картон', 1], [50, 'Белый', 1], [30, 'Картон', 2], [70, 'Серый', 2], [60, 'Серый', 3], [40, 'Картон', 3]]


paper_details.each do |paper|
  ProportionDetail.create(
    percentage: paper[0],
    product: Product.find_by_name(paper[1]),
    waste_paper_proportion_id: paper[2]
  )
end
