class ItemProcessor

  def initialize(item)
    @item = item
  end

  def update_quality_and_reduce_sell_in_days
    return if @item.name == 'Sulfuras, Hand of Ragnaros'

    if @item.name == 'Aged Brie'
      appreciate_quality
      reduce_sell_in_days
      appreciate_quality if expired?

    elsif @item.name == 'Backstage passes to a TAFKAL80ETC concert'
      appreciate_quality
      appreciate_quality if @item.sell_in <= 10
      appreciate_quality if @item.sell_in <= 5

      reduce_sell_in_days
      @item.quality = 0 if expired?

    else
      depreciate_quality
      reduce_sell_in_days
      depreciate_quality if expired?
    end
  end

  private

  def depreciate_quality
    if @item.quality > 0
      @item.quality -= 1
    end
  end

  def appreciate_quality
    if @item.quality < 50
      @item.quality += 1
    end
  end

  def expired?
    @item.sell_in < 0
  end

  def reduce_sell_in_days
    @item.sell_in -= 1
  end
end



def update_quality(items)
  items.each do |item|
    ItemProcessor.new(item).update_quality_and_reduce_sell_in_days
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

