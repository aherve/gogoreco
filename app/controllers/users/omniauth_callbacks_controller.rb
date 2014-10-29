class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.skip_confirmation!

    if @user.persisted?
      @user.confirm!
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    facebook
  end


end
