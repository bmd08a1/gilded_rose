require_relative 'constant'

def update_quality(items)
  items.each do |item|
    next if item.name == 'Sulfuras, Hand of Ragnaros'

    decrease_sell_in item

    quality_degradation_level = quality_degradation_level(item)
    updated_quality = item.quality - quality_degradation_level*UNIT

    if quality_degradation_level > 0
      item.quality = [updated_quality, MIN_QUALITY].max
    else
      item.quality = [updated_quality, MAX_QUALITY].min
    end
  end
end

def decrease_sell_in item
  return if item.name == 'Sulfuras, Hand of Ragnaros'
  item.sell_in -= 1
end

def quality_degradation_level(item)
  case item.name
  when 'Aged Brie'
    if item.sell_in > 0
      return -1
    else
      return -2
    end
  when 'Backstage passes to a TAFKAL80ETC concert'
    if item.sell_in >= 10
      return -1
    elsif item.sell_in >= 5
      return -2
    elsif item.sell_in >= 0
      return -3
    else
      return item.quality
    end
  when 'Conjured'
    if item.sell_in > 0
      return 2
    else
      return 4
    end
  else
    if item.sell_in > 0
      return 1
    else
      return 2
    end
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
