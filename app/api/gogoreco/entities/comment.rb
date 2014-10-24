module Gogoreco
  module Entities
    class Comment < Grape::Entity
      expose :pretty_id, as: :id
      expose :content, if: lambda {|s,o| o[:entity_options]["comment"][:content]}
      expose :related_evaluation, using: Gogoreco::Entities::Evaluation, if: lambda{|s,o| o[:entity_options]["comment"][:related_evaluation]}
      expose :author, using: Gogoreco::Entities::User, if: lambda{|s,o|, o[:entity_options]["comment"][:author]}
    end
  end
end
