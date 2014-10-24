module UserRecommendations
  extend ActiveSupport::Concern

  def should_like
    item_ids = evaluations.only(:item_id).distinct(:item_id)
    buddy_ids = evaluations.reduce(Hash.new(0)) do |h,evaluation|
      my_score = evaluation.score
      item = evaluation.item
      item.evaluations.not.where(author_id: id).each do |eval2|
        diff = (my_score - eval2.score).abs
        r = if diff == 0
              1
            elsif diff == 1
              0.5
            elsif diff == 2
              -0.5
            else #diff == 3
              -1
            end
        h[eval2.author_id] += r
      end
      h
    end

    @items = Hash.new(0)
    buddy_ids.each do |buddy_id,buddy_r|

      Evaluation.where(author_id: buddy_id).not.where(item_id: item_ids).each do |buddy_evaluation|
        @items[buddy_evaluation.item_id] += buddy_r * buddy_evaluation.score
      end
    end

    return [] if @items.empty?
    @items.select{|k,v| v>0}.sort_by{|k,v| v}.reverse.map(&:first).map{|id| Item.find(id)}

  end

end
