require 'rspec'
require './lib/vendor'
require './lib/item'

RSpec.describe Vendor do 
  before(:each) do 
    @vendor = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
  end

  describe '#initialize' do 
    it 'exists' do 
      expect(@vendor).to be_a Vendor 
    end
    it 'has a name' do 
      expect(@vendor.name).to eq('Rocky Mountain Fresh')
    end
    it 'starts with no inventory' do 
      expect(@vendor.inventory).to eq({})
    end
  end

  context '#stocking items' do 
    describe '#stock' do
      it 'puts an amt of item in inventory' do 
        @vendor.stock(@item1, 30)
        expect(@vendor.inventory). to eq({@item1 => 30})
      end
    end
    describe '#check stock' do 
      it 'checks amt of item in stock' do 
        expect(@vendor.check_stock(@item1)).to eq(0)
        @vendor.stock(@item1, 30)
        expect(@vendor.check_stock(@item1)).to eq(30)
      end
    end
  end

  describe '#potential_revenue' do 
    it 'returns total potential revenue of vendors stock' do 
      @vendor.stock(@item1, 35)
      @vendor.stock(@item2, 7)
      expect(@vendor.potential_revenue).to eq(29.75)
    end
  end
end

      
