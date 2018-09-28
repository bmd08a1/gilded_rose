class BackstagePassesQualityService < QualityService

  private

  def degradation_level
    if @item.sell_in >= 10
      return -1
    elsif @item.sell_in >= 5
      return -2
    elsif @item.sell_in >= 0
      return -3
    else
      return @item.quality
    end
  end
end
