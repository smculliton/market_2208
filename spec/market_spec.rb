require 'rspec'
require './lib/market'
require './lib/vendor'
require './lib/item'

RSpec.describe Market do 
  before(:each) do 
    @market = Market.new("South Pearl Street Farmers Market")

    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")

    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end

  describe '#initialize' do 
    it 'exists' do 
      expect(@market).to be_a Market 
    end
    it 'has a name' do 
      expect(@market.name).to eq('South Pearl Street Farmers Market')
    end
    it 'starts with no vendors' do 
      expect(@market.vendors).to eq([])
    end
  end

  context '#adding markets' do 
    before(:each) do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end
    it 'adds vendor to vendors list' do 
      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end
    it 'can return list of vendor names' do 
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
    it 'can return list of vendors with item in stock' do 
      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  context '#market inventories' do 
    before(:each) do 
      @vendor3.stock(@item3, 10)

      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    describe '#sorted_item_list' do 
      it 'returns alphabetical list of all items' do 
        expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
      end
    end

    describe '#total_inventory' do 
      it 'returns hash of items as keys and vendors and amount as values' do 
        expect(@market.total_inventory).to eq({
          @item1 => {
            quantity: 100,
            vendors: [@vendor1, @vendor3]
          },
          @item2 => {
            quantity: 7,
            vendors: [@vendor1]
          },
          @item4 => {
            quantity: 50,
            vendors: [@vendor2]
          },
          @item3 => {
            quantity: 35,
            vendors: [@vendor2, @vendor3]
          }
        })
      end
    end

    describe '#overstocked_items' do 
      it 'returns items sold by > 1 vendor and quantity > 50' do 
        expect(@market.overstocked_items).to eq([@item1])
      end
    end
  end

  describe '#sell' do 
    before(:each) do 
      @item5 = Item.new({name: 'Onion', price: '$0.25'})
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it 'wont sell if not enough inventory' do
      expect(@market.sell(@item1, 200)).to eq(false)
      expect(@market.sell(@item5, 1)).to eq(false)
    end

    it 'sells an item if in stock' do 
      expect(@market.sell(@item4, 5)).to eq(true)
      expect(@vendor2.check_stock(@item4)).to eq(45)
    end

    it 'sells across two vendors' do 
      expect(@market.sell(@item1, 40)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(60)
    end

    it 'doesnt decrease inventory of second vendor if first vendor has enough' do 
      expect(@market.sell(@item1, 30)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(5)
      expect(@vendor3.check_stock(@item1)).to eq(65)
    end
  end

  describe '#date' do 
    it 'returns date of the market' do 
      allow(Date).to receive(:today).and_return('1991-03-13')
      expect(@market.date).to eq('13/03/1991')
    end
  end
end
