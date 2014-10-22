require 'rails_helper'

RSpec.describe School, :type => :model do
  before(:each) do 
    User.delete_all
    School.delete_all
    @school = FactoryGirl.create(:school)
  end

  describe :basics do 
    it "validates" do 
      expect(@school.valid?).to be true
    end
  end

  #{{{ relations
  describe :relations do
    it "has schools" do 
      @user = FactoryGirl.create(:user)
      expect{
        @school.students << @user
      }.to change{@school.student_ids}.from([]).to([@user.id])
    end
  end
  #}}}

end
