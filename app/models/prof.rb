class Prof < Tag

has_and_belongs_to_many :items, class_name: "Item", inverse_of: :profs

end
