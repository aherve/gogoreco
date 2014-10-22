module Gogoreco
  module Entities
    class Comment < Grape::Entity
      expose :pretty_id, as: :id
      expose :content, if: lambda {|s,o| o[:entity_options]["comment"][:content]}
    end
  end
end
