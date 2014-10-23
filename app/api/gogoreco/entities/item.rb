module Gogoreco
  module Entities
    class Item < Grape::Entity
      expose :pretty_id, as: :id
      expose :name, if: lambda {|i,o| o[:entity_options]["item"][:name]}

      expose :comments_count, if: lambda{|i,o| o[:entity_options]["item"][:comments_count]}

      expose :lovers_count, if: lambda {|i,o| o[:entity_options]["item"][:lovers_count]}
      expose :likers_count, if: lambda {|i,o| o[:entity_options]["item"][:likers_count]}
      expose :mehers_count, if: lambda {|i,o| o[:entity_options]["item"][:mehers_count]}
      expose :haters_count, if: lambda {|i,o| o[:entity_options]["item"][:haters_count]}

      expose :latest_evaluation_at, if: lambda {|i,o| o[:entity_options]["item"][:latest_evaluation_at]}

      expose :comments, using: Gogoreco::Entities::Comment, if: lambda{|i,o| o[:entity_options]["item"][:comments]}
      expose :tags, using: Gogoreco::Entities::Tag, if: lambda{|i,o| o[:entity_options]["item"][:tags]}

      expose :current_user_score, if: lambda{|i,o| o[:entity_options]["item"][:current_user_score]} do |i,o|
        i.user_eval_score(o[:entity_options][:current_user])
      end

      expose :user_commented, if: lambda{|i,o| o[:entity_options]["item"][:user_commented]} do |i,o|
        i.user_commented(o[:entity_options][:current_user])
      end
    end
  end
end


