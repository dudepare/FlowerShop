class Order
  attr_reader :count, :code

  def initialize(count=0, code)
    @count = count < 0 ? 0 : count
    @code = code
  end

  def to_s
    "Ordered #{@count} items of item code #{@code}"
  end
end

class OrderParser

  def initialize(input="")
    @orders = []
    @input = input
    if !input.empty?
      read_orders
    end
  end

  def parse_order(line)
    count, code = line.chomp.split(" ")
    count = count.to_i
    order = Order.new(count, code)
  end

  def read_orders
    IO.foreach(@input) do | line |
      @orders << parse_order(line)
    end
  end

  def get_order
    gets
  end
end
