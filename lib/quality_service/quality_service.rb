class QualityService

  def initialize item
    @item = item
  end

  def update
    updated_quality = @item.quality - degradation_level*UNIT

    if degradation_level > 0
      @item.quality = [updated_quality, MIN_QUALITY].max
    else
      @item.quality = [updated_quality, MAX_QUALITY].min
    end
  end

  private

  def degradation_level
    raise NotImplementedError.new("please implement #degradation_level function")
  end
end
