require_relative '../lib/gilded_rose'
require_relative '../lib/constant'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { rand(MIN_INT...MAX_INT) }
    let(:initial_quality) { rand(MIN_QUALITY...(MAX_QUALITY + 1)) }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    context "Normal Item" do
      it "will reduce number of sell days left" do
        expect(item.sell_in).to eql(initial_sell_in - 1)
      end

      context "before sell date" do
        let(:initial_sell_in) { rand(1...MAX_INT) }

        it "will reduce quality by 1" do
          expect(item.quality).to eql(initial_quality - 1)
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will reduce quality by 2" do
          expect(item.quality).to eql(initial_quality - 2)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will reduce quality by 2" do
          expect(item.quality).to eql(initial_quality - 2)
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

      it "will never be on sale" do
        expect(item.sell_in).to eql(initial_sell_in)
      end

      it "will never reduce quality" do
        expect(item.quality).to eql(initial_quality)
        expect(item.quality).to eql(LEGENDARY_ITEM_QUALITY)
      end
    end

    context "Aged Brie" do
      let(:name) { "Aged Brie" }

      it "will reduce number of sell days left" do
        expect(item.sell_in).to eql(initial_sell_in - 1)
      end

      context "before sell date" do
        let(:initial_sell_in) { rand(1...MAX_INT) }

        it "will increase quality by 1" do
          expect(item.quality).to eql(initial_quality + 1)
        end
      end

      context "on sell date" do
        let(:initial_sell_in) { 0 }

        it "will increase quality by 2" do
          expect(item.quality).to eql(initial_quality + 2)
        end
      end

      context "after sell date" do
        let(:initial_sell_in) { rand(MIN_INT...0) }

        it "will increase quality by 2" do
          expect(item.quality).to eql(initial_quality + 2)
        end
      end

      context "at maximum quality" do
        let(:initial_quality) { MAX_QUALITY }

        it "will not increase quality" do
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
      ]
    }

    before { update_quality(items) }

    it "update all items' number of sell days left correctly" do
      expect(items[0].sell_in).to eql(4)
      expect(items[1].sell_in).to eql(2)
      expect(items[2].sell_in).to eql(3)
    end

    it "update all items' quality correctly" do
      expect(items[0].quality).to eql(9)
      expect(items[1].quality).to eql(11)
      expect(items[2].quality).to eql(LEGENDARY_ITEM_QUALITY)
    end
  end
end
