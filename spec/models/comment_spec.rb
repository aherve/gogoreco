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

end
