module Gogoreco
  module Entities
    class Tag < Grape::Entity
      expose :pretty_id, as: :id

      expose :name, if: lambda {|i,o| o[:entity_options]["tag"][:name]}
    end
  end
end
