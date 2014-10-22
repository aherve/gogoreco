class School
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId
  include Autocomplete

  field :name, type: String

  validates_presence_of :name
  validates_uniqueness_of :name

  index({name: 1},{unique: true, name: 'schoolNameIndex'} )

  has_and_belongs_to_many :students, class_name: "User", inverse_of: :schools

end
