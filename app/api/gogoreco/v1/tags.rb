module Gogoreco
  module V1
    class Tags < Grape::API
      format :json

      namespace :tags do

        #{{{ typeahead
        desc "typeahead with school filter if necessary"
        params do 
          requires :search, desc: "search string"
          optional :school_id, desc: "only search tags within school"
        end
        post :typeahead do 
          tags = Tag.asc(:autocomplete_length).where(autocomplete: /#{Autocomplete.normalize(params[:search])}/)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            tags = tags.any_in(item_ids: school.item_ids)
          end
          present :tags, tags, with: Gogoreco::Entities::Tag, entity_options: entity_options
        end
        #}}}

        #{{{ popular
        desc "popular with school filter if necessary"
        params do 
          optional :school_id, desc: "only search tags within school"
          optional :nmax, desc: "max tags to find(default 10)", default: 10
        end
        post :popular do 
          nmax = params[:nmax] || 10
          tags = Tag.desc(:item_ids_size)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            tags = tags.any_in(item_ids: school.item_ids)
          end
          present :tags, tags.take(nmax), with: Gogoreco::Entities::Tag, entity_options: entity_options
        end
        #}}}

      end
    end
  end
end
