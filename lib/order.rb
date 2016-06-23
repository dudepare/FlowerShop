class ItemOrder
  attr_reader :count, :code
  attr_accessor :fulfilled
  def initialize(count=0, code)
    @count = count < 0 ? 0 : count
    @code = code
    @fulfilled = false
    @bundle = {}
  end

  def add_bundle(quantity, price, bundle)
    @bundle[price] = [quantity, bundle]
  end
  
  def get_total
    total = 0
    @bundle.each do |price, qb|
      quantity = qb[0]
      total += price * quantity 
    end
    total
  end

  def tally
    if !@fulfilled
      puts "failed to fulfill #{self}"
      return
    end
    total = get_total
    puts "#{@count} #{@code} $#{total.round(2)}"
    @bundle.each do |price, qb|
      quantity = qb[0]
      bundle = qb[1]
      puts "     #{quantity} X #{bundle} $#{price}"
    end
  end

  def to_s
    "Ordered #{@count} items of item code #{@code}"
  end
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
    order = ItemOrder.new(count, code)
  end

  def read_order
    IO.foreach(@input) do | line |
      @order << parse_order(line)
    end
  end
end
