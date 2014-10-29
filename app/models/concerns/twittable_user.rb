module TwittableUser
  extend ActiveSupport::Concern

  included do 
    field :gender, type: String
    field :provider, type: String
    field :uid, type: String
    index({uid: 1},{unique: true, name: 'UsrfacebookUid', sparse: true} )
  end

  module ClassMethods
    def from_twitter_omniauth(auth)

      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]
        user.firstname = auth.info.name   # assuming the user model has a name
        user
      end

    end
  end

end
