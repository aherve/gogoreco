require 'spec_helper'
describe Gogoreco::V1::Evaluations do
  before(:each) do 
    Evaluation.delete_all
    User.delete_all
    Item.delete_all
  end

  describe :latest do
    it "get latest evaluations" do 
      i = FactoryGirl.create(:item)
      u = FactoryGirl.create(:user)
      e = Evaluation.create(author: u, item: i, score: 3)
      expect(e.valid?).to be true

      post "evaluations/latest"
      h = JSON.parse(@response.body)
      expect(h.has_key?("evaluations")).to be true
      expect(h["evaluations"].first.has_key?("id")).to be true
      expect(h["evaluations"].first["id"]).to eq e.id.to_s
    end
  end

end
