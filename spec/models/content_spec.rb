require 'rails_helper'

describe Content do
  describe '#create' do
    it "全て入力されていればOK" do
      content = create(:content)
      expect(content).to be_valid
    end
    it "nameが空ならNG" do
      content = build(:content, name: nil)
      content.valid?
      expect(content.errors[:name]).to include("を入力してください")
    end
    it "explainが空ならNG" do
      content = build(:content, explain: nil)
      content.valid?
      expect(content.errors[:explain]).to include("を入力してください")
    end
    it "priceが空ならNG" do
      content = build(:content, price: nil)
      content.valid?
      expect(content.errors[:price]).to include("を入力してください")
    end
    it "priceがinteger以外ならNG" do
      content = build(:content, price: "３００")
      content.valid?
      expect(content.errors[:price]).to include("は数値で入力してください")
    end
    it "priceが300円未満ならNG" do
      content = build(:content, price: "290")
      content.valid?
      expect(content.errors[:price]).to include("は300以上の値にしてください")
    end
    it "priceが9999999円よりも高額ならNG" do
      content = build(:content, price: "19999999")
      content.valid?
      expect(content.errors[:price]).to include("は9999999以下の値にしてください")
    end
  end
end