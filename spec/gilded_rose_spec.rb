require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { rand(MIN_INT...MAX_INT) }
    let(:initial_quality) { rand(MIN_QUALITY...(MAX_QUALITY + 1)) }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }
    before { update_quality([item]) }

    names = ["Normal item", "Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Conjured"]
    context_name_and_degradation_level_by_item_name_map = {
      "Normal item"=> {
        before_sell_date: 1,
        on_sell_date: 2,
        after_sell_date: 2
      },
      "Aged Brie"=> {
        before_sell_date: -1,
        on_sell_date: -2,
        after_sell_date: -2
      },
      "Backstage passes to a TAFKAL80ETC concert"=> {
        on_sell_date: 0,
        after_sell_date: 0,
        at_least_11_days_before_sell_date: -1,
        from_6_to_10_days_before_sell_date: -2,
        from_1_to_5_days_before_sell_date: -3
      },
      "Conjured"=> {
        before_sell_date: 2,
        on_sell_date: 4,
        after_sell_date: 4
      }
    }
    sell_in_range_by_context_name_map = {
      before_sell_date: 1...MAX_INT,
      on_sell_date: 0...1,
      after_sell_date: MIN_INT...0,
      at_least_11_days_before_sell_date: 11...MAX_INT,
      from_6_to_10_days_before_sell_date: 6...11,
      from_1_to_5_days_before_sell_date: 1...6
    }

    context "for non-legendary items" do
      names.each do |name|
        context "#{name}" do
          let(:name) { name }

          it "will reduce sell_in attribute by 1" do
            expect(item.sell_in).to eql(initial_sell_in - 1)
          end

          context_name_and_degradation_level = context_name_and_degradation_level_by_item_name_map[name]

          context_name_and_degradation_level.each do |context_name, degradation_level|
            sell_in_range = sell_in_range_by_context_name_map[context_name]

            context context_name.to_s.gsub("_", " ") do
              let(:initial_sell_in) { rand(sell_in_range) }

              if degradation_level < 0
                it "will increase quality by #{-degradation_level} unit(s)" do
                  expected_quality = [initial_quality - degradation_level, MAX_QUALITY].min
                  expect(item.quality).to eql(expected_quality)
                end
              elsif degradation_level == 0
                it "will lose all quality" do
                  expect(item.quality).to eql(MIN_QUALITY)
                end
              else
                it "will decrease quality by #{degradation_level} unit(s)" do
                  expected_quality = [initial_quality - degradation_level, MIN_QUALITY].max
                  expect(item.quality).to eql(expected_quality)
                end
              end
            end
          end
        end
      end
    end

    context "for legendary item" do
      let(:name) { "Sulfuras, Hand of Ragnaros" }
      let(:initial_quality) { LEGENDARY_ITEM_QUALITY }
      let(:item) { Item.new(name, initial_sell_in, initial_quality) }

      it "will not reduce sell_in date" do
        expect(item.sell_in).to eql(initial_sell_in)
      end

      it "will not reduce quality" do
        expect(item.quality).to eql(initial_quality)
      end
    end
  end

  context "with multiple items" do
    let(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
        Item.new("Sulfuras, Hand of Ragnaros", 3, LEGENDARY_ITEM_QUALITY),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 39),
        Item.new("Conjured", 0, 41)
      ]
    }

    before { update_quality(items) }

    it "update all items' number of sell days left correctly" do
      expect(items[0].sell_in).to eql(4)
      expect(items[1].sell_in).to eql(2)
      expect(items[2].sell_in).to eql(3)
      expect(items[3].sell_in).to eql(10)
      expect(items[4].sell_in).to eql(-1)
    end

    it "update all items' quality correctly" do
      expect(items[0].quality).to eql(9)
      expect(items[1].quality).to eql(11)
      expect(items[2].quality).to eql(LEGENDARY_ITEM_QUALITY)
      expect(items[3].quality).to eql(40)
      expect(items[4].quality).to eql(37)
    end
  end
end
