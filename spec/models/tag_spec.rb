require 'rails_helper'

RSpec.describe Tag, :type => :model do
  before(:each) do 
    Tag.delete_all
  end

  #{{{ basics
  describe :basics do 
    it "validates" do 
      expect(FactoryGirl.build(:tag).valid?).to be true
    end
  end
  #}}}

end
