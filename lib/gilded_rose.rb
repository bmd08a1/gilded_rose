require_relative 'constant'
require_relative 'quality_service/quality_service.rb'
require_relative 'quality_service/aged_brie_quality_service.rb'
require_relative 'quality_service/backstage_passes_quality_service.rb'
require_relative 'quality_service/conjured_item_quality_service.rb'
require_relative 'quality_service/normal_item_quality_service.rb'
require_relative 'quality_service/quality_service_factory.rb'

def update_quality(items)
  service_factory = QualityServiceFactory.new
  items.each do |item|
    next if item.name == 'Sulfuras, Hand of Ragnaros'
    decrease_sell_in item
    quality_service = service_factory.get_quality_service(item)
    quality_service.update
  end
end

def decrease_sell_in item
  return if item.name == 'Sulfuras, Hand of Ragnaros'
  item.sell_in -= 1
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
