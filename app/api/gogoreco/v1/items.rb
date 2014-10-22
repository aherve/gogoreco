module Gogoreco
  module V1
    class Items < Grape::API
      format :json

      namespace :items do

        #{{{ typeahead
        desc "typeahead on item names"
        params do 
          requires :search, type: String, desc: "search string"
          optional :nmax, type: Integer, desc: "max number of results (default 10)", default: 10
        end
        post :typeahead do
          nmax = params[:nmax] || 10
          items = Item.where(autocomplete: /#{Autocomplete.normalize(params[:search])}/).take(nmax) 
          present :items, items, with: Gogoreco::Entities::Item, entity_options: entity_options
        end
        #}}}

        #{{{ create
        desc "create item"
        params do 
          requires :school_names, type: Array, desc: "name of the school"
          requires :item_name, type: String, desc: "name of the item"
          optional :tag_names, type: Array, desc: "names of tags"
        end
        post do 
          check_confirmed_user!

          tags = unless params[:tag_names].blank?
                   params[:tag_names].uniq{|name| Autocomplete.normalize(name)}.map do |name|
                     if found = Tag.find_by(autocomplete: Autocomplete.normalize(name))
                       found
                     else
                       Tag.new(name: name)
                     end
                   end
                 else
                   []
                 end

          schools = params[:school_names].uniq{|name| Autocomplete.normalize(name)}.map do |name|
            if found = School.find_by(autocomplete: Autocomplete.normalize(name))
              found
            else
              School.new(name: name)
            end
          end

          i = Item.new(
            name: params[:item_name],
            schools: schools,
            creator: current_user,
            tags: tags,
          )

          if i.save
            schools.each{|s| s.save if s.new_record?} ;  schools.each(&:touch)
            tags.each{|t| t.save if t.new_record?} ;  tags.each(&:touch)
            present :item, i, with: Gogoreco::Entities::Item, entity_options: entity_options
          else
            error!(i.errors.messages)
          end
        end
        #}}}

      end

    end
  end
end
