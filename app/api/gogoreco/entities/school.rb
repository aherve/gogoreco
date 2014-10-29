module Gogoreco
  module Entities
    class School < Grape::Entity
      expose :pretty_id, as: :id
      expose :name, if: lambda {|s,o| o[:entity_options]["school"][:name]}

      expose :image, if: lambda {|s,o| o[:entity_options]["school"][:image]}
    end
  end
end

