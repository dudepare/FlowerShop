class ItemOrder

  attr_reader :count, :code
  attr_accessor :fulfilled
  
  def initialize(count=0, code)
    @count = count < 0 ? 0 : count
    @code = code.upcase
    @fulfilled = false
    @bundle = {}
  end

  def to_s
    "Ordered #{@count} items of item code #{@code}"
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
      puts "Failed to fulfill order of #{@count} #{@code}"
      return
    end
    total = get_total
    puts "#{@count} #{@code} $%.2f" % total
    @bundle.each do |price, qb|
      quantity = qb[0]
      bundle = qb[1]
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
    order = ItemOrder.new(count, code)
  end

  def read_order
    IO.foreach(@input) do | line |
      @order << parse_order(line)
    end
  end

  private :read_order, :parse_order
end
