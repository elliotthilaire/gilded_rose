
class ItemProcessor
  def initialize(item)
    @item = item
  end

  def update_quality_and_reduce_sell_in_days
    fail NotImplementedError
  end

  private

  def depreciate_quality(amount:, min_level: 0 )
    depreciated_quality = @item.quality - amount
    @item.quality = [depreciated_quality, min_level].max
  end

  def appreciate_quality(amount:, max_level: 50)
    appreciated_quality = @item.quality + amount
    @item.quality = [appreciated_quality, max_level].min
  end

  def expired?
    @item.sell_in < 0
  end

  def reduce_sell_in_days
    @item.sell_in -= 1
  end
end

class GenericItemProcessor < ItemProcessor
  def update_quality_and_reduce_sell_in_days
    depreciate_quality(amount: 1)
    reduce_sell_in_days
    depreciate_quality(amount: 1) if expired?
  end
end

class CheesyItemProcessor < ItemProcessor
  def update_quality_and_reduce_sell_in_days
    appreciate_quality(amount: 1)
    reduce_sell_in_days
    appreciate_quality(amount: 1) if expired?
  end
end

class TicketItemProcessor < ItemProcessor
  def update_quality_and_reduce_sell_in_days
    appreciate_quality(amount: 1)
    appreciate_quality(amount: 1) if @item.sell_in <= 10
    appreciate_quality(amount: 1) if @item.sell_in <= 5
    reduce_sell_in_days
    @item.quality = 0 if expired?
  end
end

class ConjuredItemProcessor < ItemProcessor
  def update_quality_and_reduce_sell_in_days
    depreciate_quality(amount: 2)
    reduce_sell_in_days
    depreciate_quality(amount: 2) if expired?
  end
end

class LegendaryItemProcessor < ItemProcessor
  def update_quality_and_reduce_sell_in_days
    return
  end
end


def update_quality(items)
  items.each do |item|
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      LegendaryItemProcessor.new(item).update_quality_and_reduce_sell_in_days
    when 'Conjured Mana Cake'
      ConjuredItemProcessor.new(item).update_quality_and_reduce_sell_in_days
    when 'Backstage passes to a TAFKAL80ETC concert'
      TicketItemProcessor.new(item).update_quality_and_reduce_sell_in_days
    when 'Aged Brie'
      CheesyItemProcessor.new(item).update_quality_and_reduce_sell_in_days
    else
      GenericItemProcessor.new(item).update_quality_and_reduce_sell_in_days
    end
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

