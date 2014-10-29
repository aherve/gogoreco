module TwittableSchool
  extend ActiveSupport::Concern

  included do 
    field :twitter_id, type: String
    field :twitter_username, type: String
  end

  def twitter_name
    twitter_username.blank? ? ("@" << name.gsub(" ","_").camelize) : "@#{twitter_username}"
  end

end
