module Facebookable
  extend ActiveSupport::Concern

  included do 
    field :gender, type: String
    field :provider, type: String
    field :uid, type: String
    field :image, type: String
    index({uid: 1},{unique: true, name: 'UsrfacebookUid', sparse: true} )
  end

  class FbConnector
    class << self
      def conn
        Faraday.new(:url => 'https://graph.facebook.com/user') do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.params["access_token"] = [FACEBOOK_APP_TOKEN,FACEBOOK_APP_SECRET].join("|")
        end
      end
    end
  end

  def fb_friends_hash
    f = Rails.cache.fetch("usrFbFriends|#{id}", expires_in: 5.minutes) do 
      provider == "facebook" ? JSON.parse(FbConnector.conn.get("/#{uid}/friends").body)["data"] : []
    end
    f || []
  end

  def fb_friend_uids
    f = (provider == "facebook" ? fb_friends_hash.map{|h| h["id"]} : [])
    f || []
  end

  def fb_app_friends
    f = (provider == "facebook" ? User.find(uid: fb_friend_uids) : [] )
    f || []
  end

  def image
    if self.image.blank? and provider.to_s == "facebook"
      "http://graph.facebook.com/#{uid}/picture"
    else
      self.image
    end
  end

  module ClassMethods
    def from_omniauth(auth)

      if user = User.find_by(email: auth.info.email, provider: nil)
        user.update_attribute(:uid, auth.uid)
        user.update_attribute(:provider, auth.provider)
        user.update_attribute(:gender, auth.info.gender)
        user
      else

        where(auth.slice(:provider, :uid)).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.firstname = auth.info.first_name   # assuming the user model has a name
          user.lastname  = auth.info.last_name   # assuming the user model has a name
          user.gender = auth.info.gender
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
