require 'spec_helper'
describe Gogoreco::V1::Teachers do 
  before(:each) do 
    Item.delete_all
    School.delete_all
    Teacher.delete_all
    User.delete_all

    @user = FactoryGirl.create(:user)
    @user.confirm!
    login(@user)
  end

  #{{{ typeahead
  describe :typeahead do 
    it "finds teachers, and filters by school" do 
      s = FactoryGirl.create(:school)

      i1 = FactoryGirl.create(:item)
      i2 = FactoryGirl.create(:item)

      t1 = FactoryGirl.create(:teacher)
      t2 = FactoryGirl.build(:teacher); t2.name = "teacher 2 name" ; t2.save

      i1.teachers << t1
      i2.teachers << t2

      i1.schools << s

      expect([s,i1,i2,t1,t2].map(&:save).reduce(:&)).to be true

      post "teachers/typeahead", search: t2.name[0..2]
      h = JSON.parse(@response.body)
      expect(h.has_key?("teachers")).to be true
      expect(h["teachers"].any?).to be true
      expect(h["teachers"].map{|h| h["id"]}.map(&:to_s).include?(t2.id.to_s) ).to be true

      post "teachers/typeahead", search: t2.name[0..2], school_id: s.id.to_s
      h = JSON.parse(@response.body)
      expect(h.has_key?("teachers")).to be true
      expect(h["teachers"].map{|h| h["id"]}.map(&:to_s).include?(t2.id.to_s) ).to be false

    end

  end
  #}}}

end
