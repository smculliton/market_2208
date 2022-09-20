class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name 
    @inventory = Hash.new(0)
  end
  
  def stock(item, amt)
    inventory[item] = amt
  end

  def check_stock(item)
    inventory[item]
  end

  def items_by_name
    inventory.map { |item| item[0].name }
  end

  def potential_revenue
    inventory.sum do |item, amt|
      amt * item.price_as_float
    end
  end
end
