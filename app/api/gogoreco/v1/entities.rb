module Gogoreco
  module V1
    class Entities < Grape::API
      format :json

      namespace :entities do 
        get do 

          present :item, [:current_user_commented, :current_user_score, :tags, :id, :name, :lovers_count, :likers_count, :mehers_count, :lovers_count, :comments_count, :comments].sort
          present :user, [:id, :firstname, :lastname, :email].sort
          present :comment, [:id, :content].sort
          present :school, [:id, :name].sort

        end
      end

    end
  end
end

