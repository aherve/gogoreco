module Gogoreco
  module V1
    class Teachers < Grape::API
      format :json

      namespace :teachers do

        #{{{ typeahead
        desc "typeahead with school filter if necessary"
        params do 
          requires :search, desc: "search string"
          optional :school_id, desc: "only search teachers within school"
        end
        post :typeahead do 
          teachers = Teacher.asc(:autocomplete_length).where(autocomplete: /#{Autocomplete.normalize(params[:search])}/)
          unless params[:school_id].blank?
            school = School.find(params[:school_id]) || error!("school not found",404)
            teachers = teachers.any_in(item_ids: school.item_ids)
          end
          present :teachers, teachers, with: Gogoreco::Entities::Teacher, entity_options: entity_options
        end
        #}}}

        #{{{ popular
        desc "popular with school filter if necessary"
        params do 
          optional :school_id, desc: "only search teachers within school"
          optional :nmax, desc: "max teachers to find(default 10)", default: 10
        end
        post :popular do 
          nmax = params[:nmax] || 10
          teachers = Teacher.desc(:item_ids_size)
          if params[:school_id]
            school = School.find(params[:school_id]) || error!("school not found",404)
            teachers = teachers.any_in(item_ids: school.item_ids)
          end
          present :teachers, teachers.take(nmax), with: Gogoreco::Entities::Teacher, entity_options: entity_options
        end
        #}}}

      end
    end
  end
end
