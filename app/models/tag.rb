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

  class << self
    def find_or_new_by_names(names)
      unless names.blank?
        names.uniq{|name| Autocomplete.normalize(name)}.map do |name|
          if found = Tag.find_by(autocomplete: Autocomplete.normalize(name))
            found
          else
            Tag.new(name: name)
          end
        end
      else
        []
      end
    end
  end
end
