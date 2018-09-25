require_relative '../lib/gilded_rose'

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

    context "Backstage Passes" do
      let(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      it "will reduce number of sell days left" do
        expect(item.sell_in).to eql(initial_sell_in - 1)
      end

      context "at least 11 days before sell date" do
        let(:initial_sell_in) { rand(11...MAX_INT) }

        it "will increase quality by 1" do
          expect(item.quality).to eql(initial_quality + 1)
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

        it "will increase quality by 2" do
          expect(item.quality).to eql(initial_quality + 2)
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

        it "will increase quality by 3" do
          expect(item.quality).to eql(initial_quality + 3)
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
  end

  context "with multiple items" do
    let(:items) {
      [
        Item.new("NORMAL ITEM", 5, 10),
        Item.new("Aged Brie", 3, 10),
        Item.new("Sulfuras, Hand of Ragnaros", 3, LEGENDARY_ITEM_QUALITY),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 39)
      ]
    }

    before { update_quality(items) }

    it "update all items' number of sell days left correctly" do
      expect(items[0].sell_in).to eql(4)
      expect(items[1].sell_in).to eql(2)
      expect(items[2].sell_in).to eql(3)
      expect(items[3].sell_in).to eql(10)
    end

    it "update all items' quality correctly" do
      expect(items[0].quality).to eql(9)
      expect(items[1].quality).to eql(11)
      expect(items[2].quality).to eql(LEGENDARY_ITEM_QUALITY)
      expect(items[3].quality).to eql(40)
    end
  end
end
