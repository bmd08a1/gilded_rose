require_relative '../lib/gilded_rose'

describe "#update_quality" do

  context "with a single item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:name) { "item" }
    let(:item) { Item.new(name, initial_sell_in, initial_quality) }

    before { update_quality([item]) }

    context "Normal Item" do
      it "will reduce number of sell days left" do
        expect(item.sell_in).to eql(initial_sell_in - 1)
      end

      context "before sell date" do
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
        let(:initial_sell_in) { -1 }
        it "will reduce quality by 2" do
          expect(item.quality).to eql(initial_quality - 2)
        end
      end

      context "at minimum quality" do
        let(:initial_quality) { 0 }
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
      ]
    }

    before { update_quality(items) }

    it "update all items' number of sell days left correctly" do
      expect(items[0].sell_in).to eql(4)
      expect(items[1].sell_in).to eql(2)
    end

    it "update all items' quality correctly" do
      expect(items[0].quality).to eql(9)
      expect(items[1].quality).to eql(11)
    end
  end
end
