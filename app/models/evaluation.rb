class Evaluation
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId

  field :score, type: Integer
  field :school_ids

  field :related_comment_ids

  belongs_to :author, class_name: "User", inverse_of: :evaluations
  belongs_to :item, class_name: "Item", inverse_of: "evaluations"

  validates_presence_of :author_id
  validates_presence_of :item_id

  validates_uniqueness_of :author_id
  validates_uniqueness_of :item_id

  index({item_id: 1, author_id: 1 },{unique: true, name: 'EvaluationItemAuthorIndex'} )

  before_save :set_schools!
  before_save :look_for_related_comments

  def schools
    school_ids.any? ? School.find(school_ids) : []
  end

  def related_comments
    related_comment_ids.blank? ? [] : Comment.find(related_comment_ids)
  end

  protected

  def set_schools!
    self.school_ids = item.school_ids rescue []
  end

  def look_for_related_comments
    if new_record? or author_id_changed? or item_id_changed?
      cs = Comment.where(author_id: author_id, item_id: item_id).only(:id,:related_evaluation_id)
      if cs.any?
        self.related_comment_ids = cs.map(&:id)
        cs.each{|c| c.set(related_evaluation_id: id)}
      end
    end
  end

end
