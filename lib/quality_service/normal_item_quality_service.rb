class NormalItemQualityService < QualityService

  private

  def degradation_level
    if @item.sell_in > 0
      return 1
    else
      return 2
    end
  end

end
