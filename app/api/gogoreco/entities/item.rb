module Gogoreco
  module Entities
    class Item < Grape::Entity
      expose :pretty_id, as: :id
      expose :name, if: lambda {|s,o| o[:entity_options]["item"][:name]}
    end
  end
end


