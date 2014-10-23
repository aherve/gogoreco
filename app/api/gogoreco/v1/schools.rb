module Gogoreco
  module V1
    class Schools < Grape::API
      format :json

      namespace :schools do 

        #{{{ typeahead
        desc "typeahead on school names"
        params do 
          requires :search, type: String, desc: "search string"
          optional :nmax, type: Integer, desc: "max number of results (default 10)", default: 10
        end
        post :typeahead do
          nmax = params[:nmax] || 10
          schools = School.asc(:autocomplete_length).where(autocomplete: /#{Autocomplete.normalize(params[:search])}/).take(nmax) 
          present :schools, schools, with: Gogoreco::Entities::School, entity_options: entity_options
        end
        #}}}

        #{{{ index
        post :index do 
          present :schools, School.all.asc(:name), with: Gogoreco::Entities::School, entity_options: entity_options
        end
        #}}}


      end

    end
  end
end
