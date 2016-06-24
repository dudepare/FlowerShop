class ItemOrder

  attr_reader :count, :code
  attr_accessor :fulfilled
  
  def initialize(count=0, code)
    @count = count < 0 ? 0 : count
    @code = code.upcase
    @fulfilled = false
    @bundles = {}
  end

  def to_s
    "Ordered #{@count} items of item code #{@code}"
  end

  def add_bundle(quantity, price, bundle)
    @bundles[bundle] = [quantity, price]
  end

  def get_bundle_info(bundle)
    @bundles.keys.include?(bundle) ? @bundles[bundle] : [0,0]
  end
  
  def get_total
    total = 0
    @bundles.each do |bundle, quantity_price|
      quantity = quantity_price[0]
      price = quantity_price[1]
      total += price * quantity 
    end
    total
  end

  def tally
    if !@fulfilled
      puts "Failed to fulfill order of #{@count} #{@code}"
      return
    end
    total = get_total
    puts "#{@count} #{@code} $%.2f" % total
    @bundles.each do |bundle, quantity_price|
      quantity = quantity_price[0]
      price = quantity_price[1]
      puts "     #{quantity} X #{bundle} $%.2f" % price
    end
  end

  public :tally, :add_bundle
  private :get_total
end

class OrderParser

  attr_reader :order

  def initialize(input="")
    @order = []
    @input = input
    if !input.empty?
      read_order
    end
  end

  def parse_order(line)
    count, code = line.chomp.split(" ")
    count = count.to_i
    code.upcase!
    item_order = ItemOrder.new(count, code)
  end

  def read_order
    IO.foreach(@input) do | line |  
      item = parse_order(line)
      next if item.count == 0
      @order << item
    end
  end

  private :read_order
  public :parse_order
end
