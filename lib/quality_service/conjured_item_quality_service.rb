class ConjuredItemQualityService < QualityService

  private

  def degradation_level
    if @item.sell_in > 0
      return 2
    else
      return 4
    end
  end
end
