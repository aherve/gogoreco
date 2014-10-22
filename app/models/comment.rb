class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId

  field :content

  belongs_to :author, class_name: "User", inverse_of: "comments"
  belongs_to :item, class_name: "User", inverse_of: "comments"

  validates_presence_of :author_id
  validates_presence_of :item_id
  validates_presence_of :content


end
