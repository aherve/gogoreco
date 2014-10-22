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
          #}}}

          #{{{ users/me/add_schools
          desc "add schools by name"
          params do 
            requires :school_names, type: Array, desc: "names of the schools to add"
          end
          post :add_schools do

            schools = params[:school_names].uniq{|name| Autocomplete.normalize(name)}.map do |name|
              if found = School.find_by(autocomplete: Autocomplete.normalize(name))
                found
              else
                School.new(name: name)
              end
            end

            schools.each{|s| current_user.schools << s }
            if current_user.save
              present :user, current_user, with: Gogoreco::Entities::User, entity_options: entity_options
            else
              error!(user.errors.messages)
            end
            
          end
          #}}}


        end
      end

    end
  end

end
