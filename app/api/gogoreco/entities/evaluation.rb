module Gogoreco
  module Entities
    class Evaluation < Grape::Entity
      expose :pretty_id, as: :id
      expose :score, if: lambda{|e,o| o[:entity_options]["evaluation"][:score]}
      expose :created_at, if: lambda{|e,o| o[:entity_options]["evaluation"][:created_at]}
      expose :updated_at, if: lambda{|e,o| o[:entity_options]["evaluation"][:updated_at]}

      expose :schools, using: Gogoreco::Entities::School, if: lambda{|e,o| o[:entity_options]["evaluation"][:schools]}
      expose :author, using: Gogoreco::Entities::User, if: lambda{|e,o| o[:entity_options]["evaluation"][:author]}
      expose :item, using: Gogoreco::Entities::Item, if: lambda{|e,o| o[:entity_options]["evaluation"][:item]}
      expose :related_comments, using: Gogoreco::Entities::Comment, if: lambda{|e,o| o[:entity_options]["evaluation"][:related_comments]}

    end
  end
end

