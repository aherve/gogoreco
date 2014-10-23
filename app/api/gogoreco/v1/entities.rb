module Gogoreco
  module V1
    class Entities < Grape::API
      format :json

      namespace :entities do 
        get do 

          present :item, [:current_user_commented, :current_user_score, :tags, :id, :name, :lovers_count, :likers_count, :mehers_count, :haters_count, :comments_count, :comments].sort
          present :user, [:id, :firstname, :lastname, :email].sort
          present :comment, [:id, :content, :related_evaluation].sort
          present :school, [:id, :name].sort
          present :evaluation, [:id, :score, :created_at, :updated_at, :schools, :author, :item, :related_comments].sort

        end
      end

    end
  end
end

