module TwittableUser
  extend ActiveSupport::Concern

  module ClassMethods
    def from_twitter_omniauth(auth)

      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]

        splitted_name = auth.info.name.chomp.strip.split(" ").map(&:strip)
        user.firstname = splitted_name.first
        user.lastname = splitted_name[1..-1].join(" ") #des fois que

        user.image_url = auth.info.image
        user
      end

    end
  end

end
