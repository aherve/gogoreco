require 'rails_helper'

RSpec.describe Item, :type => :model do

  before(:each) do 
    Item.delete_all
  end

  #{{{ basics
  describe :basics do 
    it "should validate" do 
      expect(FactoryGirl.build(:item).valid?).to be true
    end
  end
  #}}}

end


