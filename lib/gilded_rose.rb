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
    else
      if item.quality > MIN_QUALITY
        item.quality -= UNIT
      end
    end
    item.sell_in -= 1
    if item.sell_in < 0
      case item.name
      when 'Aged Brie'
        if item.quality < MAX_QUALITY
          item.quality += UNIT
        end
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = MIN_QUALITY
      else
        if item.quality > MIN_QUALITY
          item.quality -= UNIT
        end
      end
    end
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
