require 'rails_helper'

RSpec.describe Item, :type => :model do

  before(:each) do 
    Item.delete_all
    User.delete_all
  end

  #{{{ basics
  describe :basics do 
    it "should validate" do 
      expect(FactoryGirl.build(:item).valid?).to be true
    end
  end
  #}}}

  #{{{  user_eval_score
  describe :user_eval_score do
    it "works" do 
      i = FactoryGirl.create(:item)
      u = FactoryGirl.create(:user)
      expect{
      u.evaluate_item!(i,3)
      i.reload
      }.to change{i.user_eval_score(u)}.from(0).to(3)
    end
  end
  #}}}

  #{{{ user_commented
  describe :user_commented do 
    it "works" do 
      i = FactoryGirl.create(:item)
      u = FactoryGirl.create(:user)

      expect{
      c = FactoryGirl.build(:comment)
      c.author = u ; c.item = i
      c.save
      i.reload
      }.to change{i.user_commented(u)}.from(false).to(true)
    end
  end
  #}}}

end
