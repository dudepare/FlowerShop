require_relative("order")
require_relative("product_bundle")

class Application
  def self.run(inputfile)
    # load the available products
    products = self.populate_products

    # get the order from the customer
    parser = OrderParser.new(inputfile)
    customer_order = parser.order
  
    customer_order.each do |item|
      # do we have the item?
      if products.keys.include?(item.code) 
        self.compute_order(item, products[item.code])
      else
        puts "Item (#{item.code}) not found."
      end
    end

    customer_order.each do |item|
      item.tally
    end
  end

  def self.compute_order(order, flowers)
    count = order.count
    available_bundles = flowers.get_bundles.sort.reverse

    bundle_used  = [0] * (count+1)
    min_bundle   = [0] * (count+1)

    solution = self.compute_min_bundle(available_bundles, count, min_bundle, bundle_used)

    valid = self.is_valid?(bundle_used, count)
    if valid
      bundles = self.count_used_bundles(bundle_used, count)
      bundles.each_pair do |bundle, count|
        price = flowers.get_price(bundle)
        order.add_bundle(count, price, bundle)
      end
    end
    order.fulfilled = valid
  end

  def self.count_used_bundles(bundles, count)
    results = Hash.new(0)
    skip_counter = 0
    bundles.reverse.each do |step|
      if skip_counter == 0
        results[step] += 1 if step != 0
        skip_counter = step-1
      else
        skip_counter -= 1
        next
      end
    end
    results
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

  def self.is_valid?(bundles, target)
    sum = 0
    skip_counter = 0
    bundles.reverse.each do |step|
      if skip_counter == 0
        sum += step
        skip_counter = step-1
      else
        skip_counter -= 1
        next
      end
    end
    sum == target  
  end

  def self.compute_min_bundle(bundles, target_count, min_bundle, bundle_used)
    (0..target_count).each do |num|
      chosen_bundle = num
      latest_bundle = 0
      reduced_bundle = bundles.select{ |item| item <= num }
      reduced_bundle.sort!
      reduced_bundle.each do |j|
        potential_bundle = min_bundle[num-j] + 1
        if potential_bundle < chosen_bundle
          chosen_bundle = potential_bundle
          latest_bundle = j 
        end
      end
      min_bundle[num] = chosen_bundle
      bundle_used[num] = latest_bundle
    end
    min_bundle[target_count]
  end
end
