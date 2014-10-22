class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  include PrettyId
  include Autocomplete

  field :name

  has_and_belongs_to_many :schools, class_name: "School", inverse_of: :items
  validates_presence_of :school_ids

end
