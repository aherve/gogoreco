require 'spec_helper'
describe Gogoreco::V1::Items do 

  before(:each) do
    Item.delete_all
    School.delete_all
    User.delete_all
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login(@user)
  end

  #{{{ create
  describe :create do 
    before do 
    end

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

    it "set @user as creator" do
      s = FactoryGirl.create(:school)
      post "/items", {item_name: "myItem", school_names: ["haha",s.name.capitalize]}
      expect(Item.last.creator).to eq @user
      expect(@user.created_items.include?(Item.last)).to be true
    end

  end
  #}}}

  #{{{ typeahead
  describe :typeahead do 
    it "finds item" do 
      @s = FactoryGirl.create(:item)
      sstring = @s.name[0..2]
      post "items/typeahead", {search: sstring}
      h = JSON.parse(@response.body)
      expect(h.has_key?("items")).to be true
      expect(h["items"].any?).to be true
      expect(h["items"].first["id"]).to eq @s.id.to_s
    end
  end
  #}}}

end
