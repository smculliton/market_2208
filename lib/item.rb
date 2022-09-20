class Item
  attr_reader :name, :price

  def initialize(hash)
    @name = hash[:name]
    @price = hash[:price]
  end

  def price_as_float
    price.delete('$').to_f
  end
end