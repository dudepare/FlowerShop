class Engine

  def initialize
  end

  def process_order(order, flowers)
    count = order.count
    available_bundles = flowers.get_bundles.sort.reverse

    bundle_used  = [0] * (count+1)
    min_bundle   = [0] * (count+1)

    solution = compute_min_bundle(available_bundles, count, min_bundle, bundle_used)

    order.fulfilled = is_order_fulfilled?(bundle_used, count)
    
    if order.fulfilled
      bundles = count_used_bundles(bundle_used)
      bundles.each_pair do |bundle, count|
        price = flowers.get_price(bundle)
        order.add_bundle(count, price, bundle)
      end
    end
    order.fulfilled
  end

  def compute_min_bundle(bundles, target_count, min_bundle, bundle_used)
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

  def count_used_bundles(bundles)
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

  def is_order_fulfilled?(bundles, target)
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

  private :is_order_fulfilled?, :count_used_bundles, :compute_min_bundle
  public :process_order

end
