module ProductsHelper

  def product_container(position)
    if position == 0
      return "feature-left"
    elsif position == 1
      return "feature-middle"
    else
      return "feature-right"
    end
  end

  def product_quality_graph(value)
    graph =  "<div class='graph clearfix'>"
    (1..value).each do |i|
      graph += "<div class='solid'></div>"
    end
    ((value + 1)..9).each do |i|
      graph += "<div class='empty'></div>"
    end
    graph += "</div>"
    
    return graph
  end

  def product_flavour_descriptions(product)
    if product.product_flavours.size > 0
      descriptions = '<ul class="product-flavour-descriptions">'
      product.product_flavours.order(:position).each do |flavour|
        descriptions += '<li>'
        descriptions += "<b>#{ flavour.name }</b> "
        descriptions += flavour.description
        descriptions += '</li>'
      end
      descriptions += '</ul>'

      return descriptions
    end
  end

end
