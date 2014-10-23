require 'spec_helper'
describe Gogoreco::V1::Evaluations do
  before(:each) do 
    Evaluation.delete_all
    User.delete_all
    Item.delete_all
  end

  #{{{ latest
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
  #}}}

  describe :crud do 
    before do 
      @user = FactoryGirl.create(:user)
      @user.confirm!
      login(@user)

      @e = FactoryGirl.create(:evaluation)
      @e.update_attribute(:author_id, @user.id)

    end

    #{{{ update
    describe :update do 
      it "updates score" do
        initial_score = @e.score
        new_score = 4
        expect{
          put "evaluations/#{@e.id}", score: new_score
          @e.reload
        }.to change{@e.score}.from(initial_score).to(new_score)
      end
    end
    #}}}

    #{{{ destroy
    describe :destroy do 
      it "destroys evaluation" do 
        expect{
          delete "evaluations/#{@e.id}"
        }.to change{Evaluation.count}.by(-1)
      end
    end
    #}}}

  end

end
