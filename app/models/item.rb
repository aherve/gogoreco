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

end
