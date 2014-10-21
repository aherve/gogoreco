require 'spec_helper'
describe :users do 
  before(:each) do 
    User.delete_all
  end
  describe :create do 
    it "post user/create should create user" do 

      expect{
        post "/users.json", {user: {email: "foo@bar.com", password: "oijoijoij", password_confirmation: "oijoijoij"}}
      }.to change{User.count}.by(1)

    end
  end
end
