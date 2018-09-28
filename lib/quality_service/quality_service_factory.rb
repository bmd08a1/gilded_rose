class QualityServiceFactory

  def get_quality_service item
    case item.name
    when "Aged Brie"
      return AgedBrieQualityService.new(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      return BackstagePassesQualityService.new(item)
    when "Conjured"
      return ConjuredItemQualityService.new(item)
    else
      return NormalItemQualityService.new(item)
    end
  end
end
