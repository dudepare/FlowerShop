require 'minitest/autorun'
require 'minitest/spec'
require_relative("../lib/product_bundle.rb")

describe ProductBundle do
  
  describe "#create" do
    describe "when a product bundle is created" do
      it "has a name and a code" do
        a = ProductBundle.new("Orchid", "O934")
        a.name.must_equal "Orchid"
        a.code.must_equal "O934"
      end

      it "does not have bundles yet" do
        b = ProductBundle.new("Wild Flower", "W923")
        b.get_bundles.must_equal []         
      end

      it "returns 0 for every price inquiry" do
        c = ProductBundle.new("Sampaguita", "B8234")
        c.get_price(0).must_equal 0
        c.get_price(1).must_equal 0
        c.get_price(-100).must_equal 0
      end
    end
  end

  describe "#add_bundle", "#get_bundles" do
    describe "when a new bundle is added" do
      it "is returned by get_bundles" do
        a = ProductBundle.new("Plastic Flowers", "P432")
        a.add_bundle(3, 0.99)
        a.get_bundles.must_include 3
        a.add_bundle(4, 9.99)
        a.get_bundles.must_include 4
      end
    end

    describe "when a duplicate bundle is added" do
      it "returns only unique bundles" do
        a = ProductBundle.new("Flowers", "F42")
        a.add_bundle(3, 0.99)
        a.get_bundles.must_include 3
        a.add_bundle(3, 0.99)
        a.get_bundles.length.must_equal 1
      end
    end

  end

  describe "#get_price" do 
    describe "when a bundle+price is added given a bundle" do
      it "returns price paired with that bundle" do
        a = ProductBundle.new("Flowers", "F42")
        a.add_bundle(3, 0.99)
        a.get_price(3).must_equal 0.99
        a.add_bundle(5, 5.99)
        a.get_price(5).must_equal 5.99
      end
    end

    describe "when a duplicate bundle with different price is added" do
      it "returns overwrites the old price is overwritten" do
        a = ProductBundle.new("Yellow Flowers", "Y32")
        a.add_bundle(3, 0.99)
        a.get_bundles.must_include 3
        a.get_price(3).must_equal 0.99
        a.add_bundle(3, 4.99)
        a.get_price(3).must_equal 4.99
      end
    end
  end
end