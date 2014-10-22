require 'spec_helper'
describe Gogoreco::V1::Items do 

  before(:each) do
    Item.delete_all
    School.delete_all
  end

  describe :create do 

    it "creates item" do
      expect{
      post "/items", {item_name: "myItem", school_names: ["haha","hoho"]}
      }.to change{Item.count}.by(1)
    end

    it "creates school along with item" do 
      expect{
      post "/items", {item_name: "myItem", school_names: ["haha","hoho"]}
      }.to change{School.count}.by(2)
    end

    it "doesn't create school that already exist" do
      s = FactoryGirl.create(:school)
      expect{
      post "/items", {item_name: "myItem", school_names: ["haha",s.name.capitalize]}
      }.to change{School.count}.by(1)
    end

  end

end
