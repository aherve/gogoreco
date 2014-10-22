class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId
  include Autocomplete

  field :name

  has_and_belongs_to_many :schools, class_name: "School", inverse_of: :items
  validates_presence_of :school_ids

  index({name: 1},{unique: false, name: 'ItemNameIndex'} )

  belongs_to :creator, class_name: "User", inverse_of: "created_items"

  has_and_belongs_to_many :tags, class_name: "Tag", inverse_of: "items"

  has_many :comments, class_name: "Comment", inverse_of: "item"

  has_many :evaluations, class_name: "Evaluation", inverse_of: :item

  after_save :set_evals_schools_if_needed

  def hater_ids
    evaluations.where(score: 1).distinct(:author_id)
  end

  def meher_ids
    evaluations.where(score: 2).distinct(:author_id)
  end

  def liker_ids
    evaluations.where(score: 3).distinct(:author_id)
  end

  def lover_ids
    evaluations.where(score: 4).distinct(:author_id)
  end

  def comments_count
    comments.count
  end

  def haters_count
    hater_ids.count
  end

  def likers_count
    liker_ids.count
  end

  def lovers_count
    lover_ids.count
  end

  def mehers_count
    meher_ids.count
  end

  def user_eval_score(user)
    if (e = Evaluation.find_by(item_id: id, author_id: user.id))
      e.score
    else
      0
    end
  end

  def user_commented(user)
    comments.where(author_id: user.id).exists?
  end

  protected

  def set_evals_schools_if_needed
    if school_ids_changed?
      evaluations.each{|e| e.update_attribute(:school_ids, self.school_ids)}
    end
  end

end
