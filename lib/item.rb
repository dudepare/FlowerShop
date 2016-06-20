class StoreItem
 
  attr_reader :name, :code, :bundles

  def initialize(name, code)
    @name = name
    @code = code
    @bundles = {}
  end

  def add_bundle(group, price)
    @bundles[group] = price
  end

end
