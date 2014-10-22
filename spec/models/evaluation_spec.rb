require 'rails_helper'

RSpec.describe Evaluation, :type => :model do

  before(:each) do 
    User.delete_all
    Comment.delete_all
    Evaluation.delete_all
    Item.delete_all
  end

  #{{{ related_comments
  describe :related_comments do
    it "finds comments" do 
      @u = FactoryGirl.create(:user)
      @c = FactoryGirl.create(:comment)
      @i = FactoryGirl.create(:item)

      @c.update_attributes(item_id: @i.id, author_id: @u.id)
      expect(@c.valid?).to be true

      @e = FactoryGirl.build(:evaluation)
      @e.author = @u
      @e.item = @i
      expect{
        @e.save
        @e.reload
        @i.reload
        @c.reload
      }.to change{@e.related_comment_ids}.from(nil).to([@c.id])
      expect(@c.related_evaluation_id).to eq(@e.id)
      

    end
  end
  #}}}

end
