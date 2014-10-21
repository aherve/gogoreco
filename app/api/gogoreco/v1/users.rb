module Gogoreco
  module V1
    class Users < Grape::API
      format :json

      namespace :users do 

        desc "get my informations"
        post :me do 
          check_login!
          present current_user, with: Gogoreco::Entities::User, entity_options: entity_options
        end

      end

    end
  end

end
