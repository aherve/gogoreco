require 'spec_helper'
describe Gogoreco::V1::Items do 

  before(:each) do
    Comment.delete_all
    Item.delete_all
    School.delete_all
    User.delete_all
    Tag.delete_all
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
      post "/items/create", {item_name: "myItem", school_names: ["haha","hoho"]}
      }.to change{Item.count}.by(1)
    end

    it "creates school along with item" do 
      expect{
      post "/items/create", {item_name: "myItem", school_names: ["haha","hoho"]}
      }.to change{School.count}.by(2)
    end

    it "doesn't create school that already exist" do
      s = FactoryGirl.create(:school)
      expect{
      post "/items/create", {item_name: "myItem", school_names: ["haha",s.name.capitalize]}
      }.to change{School.count}.by(1)
    end

    it "set @user as creator" do
      s = FactoryGirl.create(:school)
      post "/items/create", {item_name: "myItem", school_names: ["haha",s.name.capitalize]}
      expect(Item.last.creator).to eq @user
      expect(@user.created_items.include?(Item.last)).to be true
    end

    it "creates tags" do 
      t = FactoryGirl.create(:tag)
      expect{
      post "/items/create", {item_name: "myItem", school_names: ["haha"], tag_names: ['hoho',t.name.capitalize]}
      }.to change{Tag.count}.by(1)
      expect(Tag.last.items.include?(Item.last)).to be true
      expect(Item.last.tags.include?(Tag.last)).to be true
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

  #{{{ comment
  describe :comment do 
    before do 
      @i = FactoryGirl.create(:item)
    end

    it "creates comment with proper content,author and item" do 
      expect{
        post "/items/#{@i.id}/comments/create", {content: (@content = "lol jé kiffer")}
      }.to change{Comment.count}.by(1)
      c = Comment.last
      expect(c.content).to eq @content
      expect(c.author_id).to eq @user.id
      expect(c.item_id).to eq @i.id
    end

  end
  #}}}

  #{{{ evals
  describe :evals do 
    before do 
      @item = FactoryGirl.create(:item)
    end

    it "evaluates item" do 
      expect{
      put "items/#{@item.id}/evals", score: 3 
      @item.reload
      }.to change{@item.lover_ids}.from([]).to([@user.id])
    end

  end
  #}}}

end
