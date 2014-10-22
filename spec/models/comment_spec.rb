require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before(:each) do 
    Comment.delete_all
  end

  #{{{ basics
  describe :basics do 
    it "should validate" do 
      expect(FactoryGirl.build(:comment).valid?).to be true
    end
  end
  #}}}

  #{{{ autodestroy
  describe :autodestroy do
    it "autodestroys when emptied" do 
      c = FactoryGirl.create(:comment)
      expect{
        c.update_attributes(content:nil,score:nil)
      }.to change{Comment.count}.by(-1)
    end
  end
  #}}}

end
