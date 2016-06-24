require 'minitest/autorun'
require 'minitest/spec'
require_relative("../lib/order")

describe ItemOrder do
  describe "#create" do
    describe "when you create a new ItemOrder" do
      it "remembers the count and code" do
        a = ItemOrder.new(12, "R234")
        a.count.must_equal 12
        a.code.must_equal "R234"
      end

      it "marks the order not fulfilled" do
        a = ItemOrder.new(2, "E333")
        a.fulfilled.must_equal false
      end
    end
  end

  describe "#tally" do
    describe "when order is not fulfilled" do
      it "prints out an error message" do
        a = ItemOrder.new(4, "G443")
        proc { a.tally }.must_output "Failed to fulfill order of 4 G443\n"
      end
    end

    describe "when order is fulfilled" do
      it "prints out all the bundles available" do
        b = ItemOrder.new(12, "T43")
        b.fulfilled = true
        b.add_bundle(2, 3.99, 5)
        b.add_bundle(2, 1.99, 1)
        proc { b.tally }.must_output "12 T43 $11.96\n     2 X 5 $3.99\n     2 X 1 $1.99\n"
      end
    end
  end
end

describe OrderParser do
  describe "#parse_order" do
    describe "when you give a string in this format: XX YYYY" do
      it "reads the first token as integer, second token as string upcased" do
        a = OrderParser.new
        item_order = a.parse_order("12 re324")
        item_order.count.must_equal 12
        item_order.code.must_equal "RE324"

        item_order = a.parse_order("EE E344")
        item_order.count.must_equal 0
        item_order.code.must_equal "E344"
      end
    end
  end
end