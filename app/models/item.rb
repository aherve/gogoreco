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

  has_and_belongs_to_many :haters, class_name: "User", inverse_of: :hated_items
  has_and_belongs_to_many :mehers, class_name: "User", inverse_of: :mehed_items
  has_and_belongs_to_many :likers, class_name: "User", inverse_of: :liked_items
  has_and_belongs_to_many :lovers, class_name: "User", inverse_of: :loved_items

  def comments_count
    comments.count
  end

  def haters_count
    hater_ids.size
  end

  def likers_count
    liker_ids.size
  end

  def lovers_count
    lover_ids.size
  end

  def mehers_count
    meher_ids.size
  end

  def user_eval_score(user)
    if    lover_ids.include? user.id
      4
    elsif liker_ids.include? user.id
      3
    elsif meher_ids.include? user.id
      2
    elsif hater_ids.include? user.id
      1
    else
      0
    end
  end

  def user_commented(user)
    comments.where(author_id: user.id).exists?
  end

end
