class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId
  include Autocomplete

  field :name, type: String
  validates_presence_of :name
  validates_uniqueness_of :name

  index({name: 1},{unique: true, name: 'TagNameIndex'} )


  has_and_belongs_to_many :items, class_name: "Item", inverse_of: "tags"
end
