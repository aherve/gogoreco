module Gogoreco
  module V1
    class Profs < Grape::API
      format :json

      namespace :profs do

        #{{{ typeahead
        desc "typeahead with school filter if necessary"
        params do 
          requires :search, desc: "search string"
          optional :school_id, desc: "only search profs within school"
        end
        post :typeahead do 
          profs = Prof.asc(:autocomplete_length).where(autocomplete: /#{Autocomplete.normalize(params[:search])}/)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            profs = profs.any_in(item_ids: school.item_ids)
          end
          present :profs, profs, with: Gogoreco::Entities::Prof, entity_options: entity_options
        end
        #}}}

        #{{{ popular
        desc "popular with school filter if necessary"
        params do 
          optional :school_id, desc: "only search profs within school"
          optional :nmax, desc: "max profs to find(default 10)", default: 10
        end
        post :popular do 
          nmax = params[:nmax] || 10
          profs = Prof.desc(:item_ids_size)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            profs = profs.any_in(item_ids: school.item_ids)
          end
          present :profs, profs.take(nmax), with: Gogoreco::Entities::Prof, entity_options: entity_options
        end
        #}}}

      end
    end
  end
end
