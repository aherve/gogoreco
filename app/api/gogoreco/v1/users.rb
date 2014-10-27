module Gogoreco
  module V1
    class Users < Grape::API
      format :json

      namespace :users do 

        namespace :me do 
          before do 
            check_login!
          end

          #{{{ users/me
          desc "get my informations"
          post do 
            present :user, current_user, with: Gogoreco::Entities::User, entity_options: entity_options
          end
          desc "get my informations"
          get do 
            present :user, current_user, with: Gogoreco::Entities::User, entity_options: entity_options
          end
          #}}}

          #{{{ should_like_items
          desc "get the items I should like"
          params do 
            optional :nmax, type: Integer, desc: "max number of items(default10)", default: 10
          end
          post :should_like_items do
            check_confirmed_user!
            present :items, current_user.should_like, with: Gogoreco::Entities::Item, entity_options: entity_options
          end
          #}}}

        end

        namespace ':user_id' do 
          before do 
            params do
              requires :user_id, desc: "user id"
            end
            @user = User.find(params[:user_id]) || error!("user not found",404)
          end

          #{{{ evaluations
          post :evaluations do 
            present :evaluations, @user.evaluations, with: Gogoreco::Entities::Evaluation, entity_options: entity_options
          end
          #}}}

        end
      end

    end
  end

end
