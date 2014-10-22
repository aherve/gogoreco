require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do 
    Item.delete_all
    User.delete_all
    School.delete_all
    @user = FactoryGirl.create(:user)
  end

  describe :basics do 
    it "validates" do 
      expect(@user.valid?).to be true
    end
  end

  #{{{ relations
  describe :relations do
    it "has schools" do 
      @school = FactoryGirl.create(:school)
      expect{
        @user.schools << @school
      }.to change{@user.school_ids}.from([]).to([@school.id])
    end
  end
  #}}}

  #{{{ evaluate_item!
  describe :evaluate_item! do 
    before do 
      @item = FactoryGirl.create(:item)
    end

    it "raises error if score > 3" do 
      expect{
        @user.evaluate_item!(@item,4)
      }.to raise_error
    end

    it "evaluates item, and updates item" do 
      expect(@item.lover_ids).to eq []
      expect(@item.liker_ids).to eq []
      expect(@item.hater_ids).to eq []

      @user.evaluate_item!(@item,3) ; @item.reload
      expect(@item.lover_ids).to eq [@user.id]
      expect(@item.liker_ids).to eq []
      expect(@item.hater_ids).to eq []

      @user.evaluate_item!(@item,2) ; @item.reload
      expect(@item.lover_ids).to eq []
      expect(@item.liker_ids).to eq [@user.id]
      expect(@item.hater_ids).to eq []

      @user.evaluate_item!(@item,1) ; @item.reload
      expect(@item.lover_ids).to eq []
      expect(@item.liker_ids).to eq []
      expect(@item.hater_ids).to eq [@user.id]

      @user.evaluate_item!(@item,0) ; @item.reload
      expect(@item.lover_ids).to eq []
      expect(@item.liker_ids).to eq []
      expect(@item.hater_ids).to eq []
    end

    it "evaluates item, and updates user" do 
      expect(@user.loved_item_ids).to eq []
      expect(@user.liked_item_ids).to eq []
      expect(@user.hated_item_ids).to eq []

      @user.evaluate_item!(@item,3) 
      expect(@user.loved_item_ids).to eq [@item.id]
      expect(@user.liked_item_ids).to eq []
      expect(@user.hated_item_ids).to eq []

      @user.evaluate_item!(@item,2) 
      expect(@user.loved_item_ids).to eq []
      expect(@user.liked_item_ids).to eq [@item.id]
      expect(@user.hated_item_ids).to eq []

      @user.evaluate_item!(@item,1) 
      expect(@user.loved_item_ids).to eq []
      expect(@user.liked_item_ids).to eq []
      expect(@user.hated_item_ids).to eq [@item.id]

      @user.evaluate_item!(@item,0) 
      expect(@user.loved_item_ids).to eq []
      expect(@user.liked_item_ids).to eq []
      expect(@user.hated_item_ids).to eq []
    end
  end
  #}}}

end
