class Teacher < Tag

has_and_belongs_to_many :items, class_name: "Item", inverse_of: :teachers

end
