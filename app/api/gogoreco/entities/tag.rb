module Gogoreco
  module Entities
    class Tag < Grape::Entity
      expose :pretty_id, as: :id
    end
  end
end
