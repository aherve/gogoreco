module Gogoreco
  module V1
    class Comments < Grape::API
      format :json

      namespace :comments do

        namespace ':comment_id' do 
          before do 
            params do 
              requires :comment_id, desc: "id of the comment"
            end
            @comment = Comment.find(params[:comment_id]) || error!("comment not found",404)
          end

          #{{{ update
          desc "updates comment content"
          params do 
            requires :content
          end
          put do 
            check_confirmed_user!
            error!("forbidden",403) unless @comment.author == current_user

            @comment.update_attribute(:content,params[:content])
            present :comment, @comment, with: Gogoreco::Entities::Comment, entity_options: entity_options
          end
          #}}}

          #{{{ destroy
          desc "destroy comment"
          delete do 
            check_confirmed_user!
            error!("forbidden",403) unless @comment.author == current_user

            @comment.destroy

            present :status, :deleted
          end
          #}}}

        end

      end

    end
  end
end
