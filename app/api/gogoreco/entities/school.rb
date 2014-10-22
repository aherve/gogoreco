module Gogoreco
  module Entities
    class School < Grape::Entity
      expose :pretty_id, as: :id
      expose :name, if: lambda {|s,o| o[:entity_options]["school"][:name]}
    end
  end
end

