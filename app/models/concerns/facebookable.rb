module Facebookable
  extend ActiveSupport::Concern

  included do 
    field :provider, type: String
    field :uid, type: String
  end

  module ClassMethods
    def from_omniauth(auth)

      if user = User.find_by(email: auth.info.email, provider: nil)
        user.update_attribute(:uid, auth.uid)
        user.update_attribute(:provider, auth.provider)
        user
      else

        where(auth.slice(:provider, :uid)).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.firstname = auth.info.first_name   # assuming the user model has a name
          user.lastname  = auth.info.last_name   # assuming the user model has a name
          #user.image = auth.info.image # assuming the user model has an image
          user
        end

      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end
end
