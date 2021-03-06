require 'spec_helper'
describe Gogoreco::V1::Users do 
  before(:each) do 
    Evaluation.delete_all
    User.delete_all
    School.delete_all
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login(@user)
  end

  #{{{ create
  describe :create do 
    before do 
      @h_params = {user: {
        email: "foo@bar.com",
        password: "oijoijoij",
        password_confirmation: "oijoijoij",
        firstname: "Eugene",
        lastname: "Boudin",
      }}

    end
    it "creates user" do 

      expect{ post "/users.json", @h_params}.to change{User.count}.by(1)

      expect(User.last.firstname).to eq "Eugene"
      expect(User.last.lastname).to eq "Boudin"

    end

  end
  #}}}

  #{{{ users/me
  describe :me do
    before do 
      post '/users/me', entities: {user: {email: true, firstname: true, lastname: true}}
      @hres = JSON.parse(@response.body)
    end

    it "success" do 
      expect(@response.status).to eq 201
    end

    it "has firstname" do 
      expect(@hres.has_key?("user")).to be true
      expect(@hres["user"].has_key?("firstname")).to be true
      expect(@hres["user"]["firstname"]).to eq @user.firstname
    end

    it "has lastname" do 
      expect(@hres.has_key?("user")).to be true
      expect(@hres["user"].has_key?("lastname")).to be true
      expect(@hres["user"]["lastname"]).to eq @user.lastname
    end

    it "has email" do 
      expect(@hres.has_key?("user")).to be true
      expect(@hres["user"].has_key?("email")).to be true
      expect(@hres["user"]["email"]).to eq @user.email
    end

  end
  #}}}

  #{{{ /me/add_schools (deactivated)
  #describe :add_schools do 
  #  it "adds school to my account" do 
  #    expect{
  #      post 'users/me/add_schools', school_names: [n1 = 'haha',n2='hoho']
  #      @user.reload
  #    }.to change{School.count}.by(2)
  #    expect(@user.school_ids.count).to eq 2
  #    expect(School.last.student_ids).to eq [@user.id]
  #  end

  #  it "does not create new school if already existing" do 
  #    s = FactoryGirl.create(:school)
  #    expect(s.valid?).to be true

  #    expect{
  #      post 'users/me/add_schools', school_names: [s.name]
  #      @user.reload
  #      s.reload
  #    }.to change{School.count}.by(0)
  #    expect(@user.school_ids.count).to eq 1
  #    expect(s.student_ids).to eq [@user.id]
  #  end
  #end
  #}}}

  #{{{ /id/evaluations
  describe :evaluations do
    it "gest the user's evaluations" do
      e = FactoryGirl.build(:evaluation)
      e.author = @user
      e.save
      expect(e.valid?).to be true
      post "/users/#{@user.id}/evaluations"
      h = JSON.parse(@response.body)
      expect(h.has_key?("evaluations")).to be true
      expect(h["evaluations"].first["id"]).to eq Evaluation.last.id.to_s
    end
  end
  #}}}

end
