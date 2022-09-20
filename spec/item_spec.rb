require 'rspec'
require './lib/item' 

RSpec.describe Item do 
  before(:each) do
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
  end

  describe '#initialize' do 
    it 'exists' do 
      expect(@item1).to be_a Item
    end
    it 'has a name' do 
      expect(@item1.name).to eq('Peach')
    end
    it 'has a price' do 
      expect(@item1.price).to eq('$0.75')
    end
  end

  describe '#price_as_float' do 
    it 'converts price to float' do 
      expect(@item1.price_as_float).to eq(0.75)
    end
  end
end
