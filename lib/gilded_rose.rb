require_relative 'constant'

def update_quality(items)
  items.each do |item|
    next if item.name == 'Sulfuras, Hand of Ragnaros'

    case item.name
    when 'Aged Brie'
      if item.quality < MAX_QUALITY
        item.quality += UNIT
      end
    when 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality < MAX_QUALITY
        item.quality += UNIT
        if item.sell_in < 11
          item.quality += UNIT
        end
        if item.sell_in < 6
          item.quality += UNIT
        end
      end
    when 'Conjured'
      if item.quality > MIN_QUALITY
        item.quality -= 2*UNIT
      end
    else
      if item.quality > MIN_QUALITY
        item.quality -= UNIT
      end
    end

    decrease_sell_in item

    if item.sell_in < 0
      case item.name
      when 'Aged Brie'
        if item.quality < MAX_QUALITY
          item.quality += UNIT
        end
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = MIN_QUALITY
      when 'Conjured'
        if item.quality > MIN_QUALITY
          item.quality -= 2*UNIT
        end
      else
        if item.quality > MIN_QUALITY
          item.quality -= UNIT
        end
      end
    end
  end
end

def decrease_sell_in item
  return if item.name == 'Sulfuras, Hand of Ragnaros'
  item.sell_in -= 1
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
