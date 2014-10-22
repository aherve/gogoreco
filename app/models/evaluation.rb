class Evaluation
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId

  field :score, type: Integer
  field :school_ids

  belongs_to :author, class_name: "User", inverse_of: :evaluations
  belongs_to :item, class_name: "Item", inverse_of: "evaluations"

  validates_presence_of :author_id
  validates_presence_of :item_id

  validates_uniqueness_of :author_id
  validates_uniqueness_of :item_id

  index({item_id: 1, author_id: 1 },{unique: true, name: 'EvaluationItemAuthorIndex'} )

  before_save :set_schools!

  def schools
    school_ids.any? ? School.find(school_ids) : []
  end

  protected

  def set_schools!
    self.school_ids = item.school_ids
  end
end
