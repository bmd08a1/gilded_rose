require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { rand(MIN_INT...MAX_INT) }
    let(:initial_quality) { rand(MIN_QUALITY...(MAX_QUALITY + 1)) }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    context "Normal Item" do
      context "before sell date" do
        let(:initial_sell_in) { rand(1...MAX_INT) }

        it "will reduce quality by 1 unit(s)" do
          expect(item.quality).to eql(initial_quality - UNIT)
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will reduce quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality - 2*UNIT)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will reduce quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality - 2*UNIT)
        end
      end

      context "at minimum quality" do
        let(:initial_quality) { MIN_QUALITY }

        it "will not reduce quality" do
          expect(item.quality).to eql(initial_quality)
        end
      end
    end

    context "Legendary Item" do
      let(:name) { "Sulfuras, Hand of Ragnaros" }
      let(:initial_quality) { LEGENDARY_ITEM_QUALITY }

      it "will never reduce quality" do
        expect(item.quality).to eql(initial_quality)
        expect(item.quality).to eql(LEGENDARY_ITEM_QUALITY)
      end
    end

    context "Aged Brie" do
      let(:name) { "Aged Brie" }

      context "before sell date" do
        let(:initial_sell_in) { rand(1...MAX_INT) }

        it "will increase quality by 1 unit(s)" do
          expect(item.quality).to eql(initial_quality + UNIT)
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will increase quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality + 2*UNIT)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will increase quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality + 2*UNIT)
        end
      end

      context "at maximum quality" do
        let(:initial_quality) { MAX_QUALITY }

        it "will not increase quality" do
          expect(item.quality).to eql(initial_quality)
        end
      end
    end

    context "Backstage Passes" do
      let(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      context "at least 11 days before sell date" do
        let(:initial_sell_in) { rand(11...MAX_INT) }

        it "will increase quality by 1 unit(s)" do
          expect(item.quality).to eql(initial_quality + UNIT)
        end

        context "at maximum quality" do
          let(:initial_quality) { MAX_QUALITY }

          it "will not increase quality" do
            expect(item.quality).to eql(initial_quality)
          end
        end
      end

      context "6 to 10 days before sell date" do
        let(:initial_sell_in) { rand(6...11) }

        it "will increase quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality + 2*UNIT)
        end

        context "at maximum quality" do
          let(:initial_quality) { MAX_QUALITY }

          it "will not increase quality" do
            expect(item.quality).to eql(initial_quality)
          end
        end
      end

      context "1 to 5 days before sell date" do
        let(:initial_sell_in) { rand(1...6) }

        it "will increase quality by 3 unit(s)" do
          expect(item.quality).to eql(initial_quality + 3*UNIT)
        end

        context "at maximum quality" do
          let(:initial_quality) { MAX_QUALITY }

          it "will not increase quality" do
            expect(item.quality).to eql(initial_quality)
          end
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will have 0 quality" do
          expect(item.quality).to eql(MIN_QUALITY)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will have 0 quality" do
          expect(item.quality).to eql(MIN_QUALITY)
        end
      end
    end

    context "Conjured" do
      let(:name) { 'Conjured'}

      context "before sell date" do
        let(:initial_sell_in) { rand(1...MAX_INT) }

        it "will reduce quality by 2 unit(s)" do
          expect(item.quality).to eql(initial_quality - 2*UNIT)
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will reduce quality by 4 unit(s)" do
          expect(item.quality).to eql(initial_quality - 4*UNIT)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will reduce quality by 4 unit(s)" do
          expect(item.quality).to eql(initial_quality - 4*UNIT)
        end
      end

      context "at minimum quality" do
        let(:initial_quality) { MIN_QUALITY }

        it "will not reduce quality" do
          expect(item.quality).to eql(initial_quality)
        end
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

describe "#decrease_sell_in" do
  let(:initial_sell_in) { rand(MIN_INT...MAX_INT) }
  let(:initial_quality) { rand(0...51) }
  before { decrease_sell_in(item) }

  context "for items on sale" do
    names = ["Normal item", "Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Conjured"]

    names.each do |name|
      let(:item) { Item.new(name, initial_sell_in, initial_quality) }

      context "#{name}" do
        it "will reduce number of sell days left by 1" do
          expect(item.sell_in).to eql(initial_sell_in - 1)
        end
      end
    end
  end

  context "for legendary item" do
    let(:item) { Item.new("Sulfuras, Hand of Ragnaros", initial_sell_in, LEGENDARY_ITEM_QUALITY) }

    it "will not reduce number of sell days left" do
      expect(item.sell_in).to eql(initial_sell_in)
    end
  end
end
