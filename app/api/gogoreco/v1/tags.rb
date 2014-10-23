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
          tags = Tag.where(autocomplete: /#{Autocomplete.normalize(params[:search])}/)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            tags = tags.any_in(item_ids: school.item_ids)
          end
          present :tags, tags, with: Gogoreco::Entities::Tag, entity_options: entity_options
        end
        #}}}

      end
    end
  end
end
