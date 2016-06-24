class ProductBundle
 
  attr_reader :name, :code

  def initialize(name, code)
    @name = name
    @code = code.upcase
    @bundles = {}
  end

  def add_bundle(count, price)
    @bundles[count] = price
  end

  def get_bundles
    @bundles.keys
  end

  def get_price(count)
    price = 0
    if @bundles.keys.include?(count)
      price = @bundles[count]
    end
    price
  end

  public :add_bundle, :get_bundles, :get_price
end
