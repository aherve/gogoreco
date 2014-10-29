module TwittableUser
  extend ActiveSupport::Concern

  module ClassMethods
    def from_twitter_omniauth(auth)

      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]
        user.firstname = auth.info.name   # assuming the user model has a name
        user.image_url = auth.info.image
        user
      end

    end
  end

end
