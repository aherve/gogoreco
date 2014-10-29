module Gogoreco
  module V1
    class Entities < Grape::API
      format :json

      namespace :entities do 
        get do 

          present :item, [:current_user_comments, :schools,:current_user_commented, :current_user_score, :tags, :id, :name, :lovers_count, :likers_count, :mehers_count, :haters_count, :comments_count, :comments, :latest_evaluation_at].sort
          present :user, [:id, :firstname, :lastname, :email, :image].sort
          present :comment, [:author,:id, :content, :related_evaluation].sort
          present :school, [:id, :name].sort
          present :evaluation, [:id, :score, :created_at, :updated_at, :schools, :author, :item, :related_comments].sort
          present :tag, [:id, :name].sort
          present :teacher, [:id, :name].sort

        end
      end

    end
  end
end

