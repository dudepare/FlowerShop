require_relative("engine")
require_relative("order")
require_relative("product_bundle")

class Application
  
  def self.run(input)
    products = self.populate_products
    order_engine = Engine.new
    
    parser = OrderParser.new(input)
    customer_order = parser.order  
    customer_order.each do |item|
      if products.keys.include?(item.code) 
        order_engine.process_order(item, products[item.code])
      else
        puts "Item (#{item.code}) not found."
      end
    end

    customer_order.each do |item|
      item.tally
    end
  end
  
  def self.populate_products
    roses = ProductBundle.new("Roses", "R12")
    roses.add_bundle(5, 6.99)
    roses.add_bundle(10, 12.99)
    
    lilies = ProductBundle.new("Lilies", "L09")
    lilies.add_bundle(3, 9.95)
    lilies.add_bundle(6, 16.95)
    lilies.add_bundle(9, 24.95)
    
    tulips = ProductBundle.new("Tulips", "T58")
    tulips.add_bundle(3, 5.95)
    tulips.add_bundle(5, 9.95)
    tulips.add_bundle(9, 16.99)

    products = {}
    products[roses.code] = roses
    products[lilies.code] = lilies
    products[tulips.code] = tulips
    products
  end

end