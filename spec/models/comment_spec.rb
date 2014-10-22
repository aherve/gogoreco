require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before(:each) do 
    School.delete_all
    User.delete_all
    Evaluation.delete_all
    Item.delete_all
    Comment.delete_all
  end

  #{{{ basics
  describe :basics do 
    it "should validate" do 
      expect(FactoryGirl.build(:comment).valid?).to be true
    end
  end
  #}}}

  #{{{ related_evaluations
  describe :related_evaluations do
    it "works" do
      @u = FactoryGirl.create(:user)
      @e = FactoryGirl.create(:evaluation)
      @i = FactoryGirl.create(:item)

      @e.update_attributes(item_id: @i.id, author_id: @u.id)
      expect(@e.valid?).to be true
      expect(@i.valid?).to be true

      @c = FactoryGirl.build(:comment)
      @c.author = @u
      @c.item = @i
      expect{
        @c.save
        @c.reload
        @i.reload
        @e.reload
      }.to change{@c.related_evaluation_id}.from(nil).to(@e.id)
      expect(@e.related_comment_ids).to eq([@c.id])
      
    end

  end
  #}}}

end
