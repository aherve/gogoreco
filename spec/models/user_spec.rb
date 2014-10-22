require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do 
    User.delete_all
    School.delete_all
    @user = FactoryGirl.create(:user)
  end

  describe :basics do 
    it "validates" do 
      expect(@user.valid?).to be true
    end
  end

  #{{{ relations
  describe :relations do
    it "has schools" do 
      @school = FactoryGirl.create(:school)
      expect{
        @user.schools << @school
      }.to change{@user.school_ids}.from([]).to([@school.id])
    end
  end
  #}}}

end
