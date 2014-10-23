module UserRecommendations
  extend ActiveSupport::Concern

  def should_like
    evaluations.reduce(Hash.new(0)) do |h,evaluation|
      my_score = evaluation.score
      item = evaluation.item.only(:evaluation_ids, :id)
    end
  end

end
