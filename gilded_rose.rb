
def depreciate_quality(item)
  if item.quality > 0
    item.quality -= 1
  end
end

def appreciate_quality(item)
  if item.quality < 50
    item.quality += 1
  end
end

def expired?(item)
  item.sell_in < 0
end

def update_quality_for_item(item)
  return if item.name == 'Sulfuras, Hand of Ragnaros'

  if item.name == 'Aged Brie'
    appreciate_quality(item)

  elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
    appreciate_quality(item)
    appreciate_quality(item) if item.sell_in <= 10
    appreciate_quality(item) if item.sell_in <= 5

  else
    depreciate_quality(item)
  end


  item.sell_in -= 1


  if expired?(item)
    if item.name == 'Aged Brie'
      appreciate_quality(item)

    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      item.quality = 0

    else
      depreciate_quality(item)
    end
  end
end



def update_quality(items)
  items.each do |item|
    update_quality_for_item(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

