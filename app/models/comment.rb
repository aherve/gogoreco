class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId

  field :content
  field :related_evaluation_id

  belongs_to :author, class_name: "User", inverse_of: "comments"
  belongs_to :item, class_name: "User", inverse_of: "comments"

  validates_presence_of :author_id
  validates_presence_of :item_id
  validates_presence_of :content

  before_save :look_for_related_evaluations
  after_create :tweet_if_loved!

  def related_evaluation
    related_evaluation_id.nil? ? nil : Evaluation.find(related_evaluation_id)
  end

  protected

  def look_for_related_evaluations
    if new_record? or author_id_changed? or item_id_changed?
      es = Evaluation.where(author_id: author_id, item_id: item_id).only(:id, :related_comment_ids)
      if es.any?
        self.related_evaluation_id = es.map(&:id).first
        es.each{|e| e.add_to_set(related_comment_ids: id)}
      end
    end
  end

  def tweet_if_loved!
    if related_evaluation and related_evaluation.score == 4
      TwitterBot.delay.tweet_comment!(comment)
    end
  end

end
