require 'spec_helper'
describe Gogoreco::V1::Schools do 
  before(:each) do 
    School.delete_all
  end

  #{{{ typeahead
  describe :typeahead do 
    it "finds school" do 
      @s = FactoryGirl.create(:school)
      sstring = @s.name[0..2]
      post "schools/typeahead", {search: sstring}
      h = JSON.parse(@response.body)
      expect(h.has_key?("schools")).to be true
      expect(h["schools"].any?).to be true
      expect(h["schools"].first["id"]).to eq @s.id.to_s
    end
  end
  #}}}

end
