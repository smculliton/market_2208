require 'date'

class Market 
  attr_reader :name, :vendors

  def initialize(name)
    @name = name 
    @vendors = []
  end

  def date
    date = Date.today.to_s
    "#{date[8..9]}/#{date[5..6]}/#{date[0..3]}"
  end

  def add_vendor(vendor)
    vendors << vendor
  end

  def vendor_names
    vendors.map(&:name)
  end

  def vendors_that_sell(item)
    vendors.select { |vendor| vendor.inventory.keys.include?(item) }
  end

  def sorted_item_list
    list = []
    vendors.each do |vendor|
      list << vendor.items_by_name
    end
    list.flatten.uniq.sort
  end

  def overstocked_items
    overstock = total_inventory.select do |item, info|
      info[:quantity] > 50 && info[:vendors].length > 1
    end
    overstock.keys
  end

  def total_inventory
    all_inventory = {}
    vendors.each do |vendor|
      vendor.inventory.each do |item|
        all_inventory[item[0]] = item_info(item, all_inventory)
      end
    end
    all_inventory
  end

  def item_info(item, inventory_hash)
    quantity = item[1]
    quantity += inventory_hash[item[0]][:quantity] unless inventory_hash[item[0]] == nil
    { quantity: quantity, vendors: vendors_that_sell(item[0]) }
  end

  def sell(item, amount)
    return false if sorted_item_list.none?(item.name)
    return false if total_inventory[item][:quantity] < amount

    total_inventory[item][:vendors].each do |vendor|
      if vendor.inventory[item] < amount
        amount -= vendor.inventory[item]
        vendor.inventory[item] = 0
      else
        vendor.inventory[item] -= amount
        break
      end
    end
    true
  end
end