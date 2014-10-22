module Gogoreco
  module V1
    class Items < Grape::API
      format :json

      namespace :items do

        #{{{ create
        desc "create item"
        params do 
          requires :school_names, type: Array, desc: "name of the school"
          requires :item_name, type: String, desc: "name of the item"
        end
        post do 
          schools = params[:school_names].uniq{|name| Autocomplete.normalize(name)}.map do |name|
            if found = School.find_by(autocomplete: Autocomplete.normalize(name))
              found
            else
              School.new(name: name)
            end
          end

          i = Item.new(name: params[:item_name], schools: schools)
          if i.save
            schools.each{|s| s.save if s.new_record?}
            schools.each(&:touch)
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
