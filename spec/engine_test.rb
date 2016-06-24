require 'minitest/autorun'
require 'minitest/spec'
require_relative("../lib/engine")
require_relative("../lib/order")
require_relative("../lib/product_bundle")

describe Engine do
  describe "#process_order" do
    
    before do
      @roses = ProductBundle.new("Roses", "R12")
      @roses.add_bundle(5, 6.99)
      @roses.add_bundle(10, 12.99)

      @tulips = ProductBundle.new("Tulips", "T58")
      @tulips.add_bundle(3, 5.95)
      @tulips.add_bundle(5, 9.95)
      @tulips.add_bundle(9, 16.99)
    end
    
    describe "when order matches a bundle" do
      it "is marked fulfilled" do
        order = ItemOrder.new(10, "R12")
        engine = Engine.new

        engine.process_order(order, @roses)
        order.fulfilled.must_equal true
        quantity_price = order.get_bundle_info(10)
        quantity_price[0].must_equal 1
        quantity_price = order.get_bundle_info(5)
        quantity_price[0].must_equal 0 
      end
    
      it "chooses the largest possible bundle" do
        order = ItemOrder.new(20, "R12")
        engine = Engine.new
        engine.process_order(order, @roses)
        order.fulfilled.must_equal true
        quantity_price = order.get_bundle_info(10)
        quantity_price[0].must_equal 2
        quantity_price.inject(:*).must_equal 12.99*2
        quantity_price = order.get_bundle_info(5)
        quantity_price[0].must_equal 0
      end
    end

    describe "when the customer orders 15 on tulips" do
      it "returns 1x9 2x3" do
        order = ItemOrder.new(15, "T58")
        engine = Engine.new
        engine.process_order(order, @tulips)
        order.get_bundle_info(9)[0].must_equal 1
        order.get_bundle_info(5)[0].must_equal 0
        order.get_bundle_info(3)[0].must_equal 2
      end
    end

    describe "when the customer orders 14 on tulips" do
      it "returns 1x9 1x5" do
        order = ItemOrder.new(14, "T58")
        engine = Engine.new
        engine.process_order(order, @tulips)
        order.get_bundle_info(9)[0].must_equal 1
        order.get_bundle_info(5)[0].must_equal 1
        order.get_bundle_info(3)[0].must_equal 0
      end
    end

    describe "when the customer orders 13 on tulips" do
      it "returns 2x5 1x3" do
        order = ItemOrder.new(13, "T58")
        engine = Engine.new
        engine.process_order(order, @tulips)
        order.get_bundle_info(9)[0].must_equal 0
        order.get_bundle_info(5)[0].must_equal 2
        order.get_bundle_info(3)[0].must_equal 1
      end
    end

    describe "when the customer orders 6 on tulips" do
      it "returns 2x3" do
        order = ItemOrder.new(6, "T58")
        engine = Engine.new
        engine.process_order(order, @tulips)
        order.get_bundle_info(9)[0].must_equal 0
        order.get_bundle_info(5)[0].must_equal 0
        order.get_bundle_info(3)[0].must_equal 2
      end
    end

    describe "when order does not match a bundle" do
      it "remains not fulfilled" do
        order = ItemOrder.new(1, "R12")
        engine = Engine.new
        engine.process_order(order, @roses)
        order.fulfilled.must_equal false  
        order.get_bundle_info(10)[0].must_equal 0
        order.get_bundle_info(5)[0].must_equal 0
      end
    end

    describe "when order is negative" do
      it "remains not fulfilled" do
        order = ItemOrder.new(-100, "R12")
        engine = Engine.new
        engine.process_order(order, @roses)
        order.fulfilled.must_equal false  
        order.get_bundle_info(10)[0].must_equal 0
        order.get_bundle_info(5)[0].must_equal 0
      end
    end

    describe "when order is 0" do
      it "remains not fulfilled" do
        order = ItemOrder.new(0, "R12")
        engine = Engine.new
        engine.process_order(order, @roses)
        order.fulfilled.must_equal false  
        order.get_bundle_info(10)[0].must_equal 0
        order.get_bundle_info(5)[0].must_equal 0
      end
    end
  end
end
