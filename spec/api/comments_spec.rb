describe Gogoreco::V1::Comments do 
  before(:each) do 
    Comment.delete_all
    User.delete_all

    @user = FactoryGirl.create(:user)
    @user.confirm!
    login(@user)
  end

  describe :crud do 
    before do 
      @c = FactoryGirl.create(:comment)
      @c.update_attribute(:author_id, @user.id)
    end

    #{{{ update
    describe :update do 
      it "updates content" do
      initial_content = @c.content.dup
      new_content = "finalement j'aime plus"
      expect{
        put "comments/#{@c.id}", content: new_content
        @c.reload
      }.to change{@c.content}.from(initial_content).to(new_content)
      end
    end
    #}}}

    #{{{ destroy
    describe :destroy do 
      it "destroys comment" do 
        expect{
          delete "comments/#{@c.id}"
        }.to change{Comment.count}.by(-1)
      end
    end
    #}}}

  end
end
