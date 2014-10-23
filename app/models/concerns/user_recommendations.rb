module UserRecommendations
  extend ActiveSupport::Concern

  def should_like
    buddys = items.only(:id, :user_ids)
  end

end
