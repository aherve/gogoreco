module TwittableSchool
  extend ActiveSupport::Concern

  included do 
    field :twitter_id, type: String
    field :twitter_username, type: String
    field :image, type: String

    after_save :set_image!

  end

  def twitter_name
    twitter_username.blank? ? ("@" << name.gsub(" ","_").camelize) : "@#{twitter_username}"
  end

  protected


  def set_image!
    self.delay.update_attribute(:image, get_image)
  end

  def get_image
    return nil unless twitter_id
    cl = TwitterBot.new.client
    image = cl.user(twitter_id.to_i).profile_image_url.to_s rescue nil
  end
  

end
