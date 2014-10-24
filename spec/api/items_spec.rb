require 'spec_helper'
describe Gogoreco::V1::Items do 

  before(:each) do
    Prof.delete_all
    Evaluation.delete_all
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

    it "creates associated comment" do expect{
        post "/items/create", {item_name: "myItem", school_names: ["haha"], comment_content: "my comment"}
      }.to change{Comment.count}.by(1)
      expect(Comment.last.item_id).to eq Item.last.id
      expect(Item.last.comments.last.id).to eq Comment.last.id
    end

    it "creates associated evaluation" do 
      expect{
        post "/items/create", {item_name: "myItem", school_names: ["haha"], comment_content: "my comment", eval_score: 3}
      }.to change{Evaluation.count}.by(1)
      expect(Evaluation.last.item_id).to eq Item.last.id
      expect(Item.last.evaluations.last.id).to eq Evaluation.last.id
      expect(Comment.last.related_evaluation_id).to eq Evaluation.last.id
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

    it "filters by tags" do 
      @t = FactoryGirl.create(:tag)
      @i = FactoryGirl.create(:item)

      @i.tags << @t ; @i.save ; @i.reload
      expect(@i.tag_ids.include?(@t.id)).to be true

      post "items/typeahead", {tag_ids: [@t.id]}
      h = JSON.parse(@response.body)
      expect(h.has_key?("items")).to be true
      expect(h["items"].any?).to be true
      expect(h["items"].first["id"]).to eq @i.id.to_s
    end

    it "filters by profs" do 
      @t = FactoryGirl.create(:prof)
      @i = FactoryGirl.create(:item)

      @i.profs << @t ; @i.save ; @i.reload
      expect(@i.prof_ids.include?(@t.id)).to be true

      post "items/typeahead", {prof_ids: [@t.id]}
      h = JSON.parse(@response.body)
      expect(h.has_key?("items")).to be true
      expect(h["items"].any?).to be true
      expect(h["items"].first["id"]).to eq @i.id.to_s
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
        put "items/#{@item.id}/evals", score: 4
        @item.reload
      }.to change{@item.lover_ids}.from([]).to([@user.id])
    end

  end
  #}}}

  #{{{ tags
  describe :tags do
    before do 
      @i = FactoryGirl.create(:item)
      @t = FactoryGirl.create(:tag)
      @i.tags << @t ; @t.items << @i 
      @i.save ; @t.save ; @i.reload ; @t.reload

      @fancy_name = "hahaha hohoho huhuhu"
    end

    describe :add do
      it "adds tag" do 
        expect{
        post "/items/#{@i.id}/tags", tag_names: [@t.name, @fancy_name]
        @i.reload
        }.to change{@i.tags.map(&:name).sort}.from([@t.name]).to([@t.name,@fancy_name].sort)
      end
    end

    describe :remove do 
      it 'removes tags' do 
        expect{
        delete "/items/#{@i.id}/tags", tag_names: [@t.name, @fancy_name]
        @i.reload
        }.to change{@i.tags.map(&:name).sort}.from([@t.name]).to([])
      end
    end

    describe :put do
      it "set tags" do 
        expect{
        put "/items/#{@i.id}/tags", tag_names: [@fancy_name]
        @i.reload
        }.to change{@i.tags.map(&:name).sort}.from([@t.name]).to([@fancy_name])
      end
    end

  end
  #}}}

  #{{{ latest_evaluated
  describe :latest_evaluated do 
    it "should take latest evaluated items" do 
      @i = FactoryGirl.create(:item)

        post "items/latest_evaluated"
        h = JSON.parse(@response.body)
        expect(h["items"].size).to eq 0

        @user.evaluate_item!(@i,1)
        @i.reload

        post "items/latest_evaluated"
        h = JSON.parse(@response.body)
        expect(h["items"].size).to eq 1

    end
  end
  #}}}

end
