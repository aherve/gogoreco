module Gogoreco
  module Entities
    class Teacher < Grape::Entity
      expose :pretty_id, as: :id

      expose :name, if: lambda {|i,o| o[:entity_options]["teacher"][:name]}
    end
  end
end

