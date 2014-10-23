module Gogoreco
  module V1
    class Items < Grape::API
      format :json

      namespace :items do

        #{{{ typeahead
        desc "typeahead on item names"
        params do 
          optional :search, type: String, desc: "search string"
          optional :nmax, type: Integer, desc: "max number of results (default 10)", default: 10
          optional :tag_ids, type: Array, desc: "filter by tags"
          optional :school_ids, type: Array, desc: "filter by schools"
        end
        post :typeahead do
          error!("please search at least something") if params[:school_ids].blank? and params[:tag_ids].blank? and params[:search].blank?

          found = Item.asc(:autocomplete_length)
          unless params[:school_ids].blank?
            found = found.all_in(school_ids: params[:school_ids])
          end

          unless params[:tag_ids].blank?
            found = found.all_in(tag_ids: params[:tag_ids])
          end

          unless params[:search].blank?
            found = found.where(autocomplete: /#{Autocomplete.normalize(params[:search])}/)
          end

          nmax = params[:nmax] || 10

          items = found.take(nmax) 
          present :items, items, with: Gogoreco::Entities::Item, entity_options: entity_options
        end
        #}}}

        #{{{ create
        desc "create item"
        params do 
          requires :school_names, type: Array, desc: "name of the school"
          requires :item_name, type: String, desc: "name of the item"
          optional :tag_names, type: Array, desc: "names of tags"
          optional :eval_score, type: Integer, desc: "evaluation score if the item has to be linked to an evaluation"
          optional :comment_content, type: String, desc: "the comment content if any"
        end
        post :create do 
          check_confirmed_user!

          tags = Tag.find_or_new_by_names(params[:tag_names])

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
            if params[:comment_content]
              c = Comment.new(
                content: params[:comment_content],
                author: current_user,
                item: i,
              )
              c.save
            end

            if params[:eval_score]
              e = Evaluation.new(
                score: params[:eval_score],
                author: current_user,
                item: i,
              )
              e.save
            end

            schools.each{|s| s.save if s.new_record?} ;  schools.each(&:touch)
            tags.each{|t| t.save if t.new_record?} ;  tags.each(&:touch)

            present :item, i, with: Gogoreco::Entities::Item, entity_options: entity_options

          else
            error!(i.errors.messages)
          end
        end
        #}}}

        #{{{ latest_evaluated
        desc "get latest evaluated items"
        params do 
          optional :nmax, type: Integer, desc: "max items count(default 10)", default: 10
        end
        post :latest_evaluated do
          n = params[:nmax] || 10
          is = Item.desc(:latest_evaluation_at).not.where(latest_evaluation_at: nil).take(n)
          present :items, is, with: Gogoreco::Entities::Item, entity_options: entity_options
        end
        #}}}

        #{{{ you_should_like
        desc "items the user has not commented, but should like"
        post :you_should_like do
          check_confirmed_user!
          present :items, current_user.should_like, with: Gogoreco::Entities::Item, entity_options: entity_options
        end
        #}}}

        namespace ':item_id' do 
          before do 
            params do 
              requires :item_id, desc: "id of the item"
            end
            @item = Item.find(params[:item_id]) || error!("item not found",404)
          end

          #{{{ get
          desc "get an item from its id"
          post do 
            present :item, @item, with: Gogoreco::Entities::Item, entity_options: entity_options
          end
          #}}}

          namespace :tags do 

            #{{{ add
            desc "add tags by name"
            params do 
              requires :tag_names, type: Array, desc: "names of the tags to add"
            end
            post do
              check_confirmed_user!
              error!("please provide tag_names") if params[:tag_names].blank?
              tags = Tag.find_or_new_by_names(params[:tag_names])

              @item.tags << tags
              if (tags.map(&:save) << @item.save).reduce(:&)
                present :item, @item, with: Gogoreco::Entities::Item, entity_options: entity_options
              else
                error!("something went wrong")
              end
            end
            #}}}

            #{{{ remove
            desc "remove tags by name"
            params do 
              requires :tag_names, type: Array, desc: "names of the tags to remove"
            end
            delete do 
              check_confirmed_user!
              error!("please provide tag_names") if params[:tag_names].blank?
              tags = Tag.find_or_new_by_names(params[:tag_names])

              @item.tags -= tags
              if (tags.map(&:save) << @item.save).reduce(:&)
                present :item, @item, with: Gogoreco::Entities::Item, entity_options: entity_options
              else
                error!("something went wrong")
              end
            end
            #}}}

            #{{{ put
            desc "set the tag list"
            params do 
              requires :tag_names, type: Array, desc: "names of the tags to set"
            end
            put do 
              check_confirmed_user!
              error!("please provide tag_names") if params[:tag_names].blank?
              tags = Tag.find_or_new_by_names(params[:tag_names])

              @item.tags = tags
              if (tags.map(&:save) << @item.save).reduce(:&)
                present :item, @item, with: Gogoreco::Entities::Item, entity_options: entity_options
              else
                error!("something went wrong")
              end
            end
            #}}}

          end

          namespace :comments do 

            #{{{ post comment
            desc "post a comment"
            params do 
              requires :content, desc: "the comment content"
            end
            post :create do 
              check_confirmed_user!

              c = Comment.new(
                author: current_user,
                item: @item,
                content: params[:content],
              )

              if c.save
                present :comment, c, with: Gogoreco::Entities::Comment, entity_options: entity_options
                present :status, :saved
              else
                error!(c.errors.messages)
              end
            end
            #}}}

          end

          namespace :evals do 

            #{{{ evaluates
            desc "evaluates an item"
            params do 
              requires :score, type: Integer, desc: "integer between 0 and 3"
            end
            put do
              check_confirmed_user!
              if current_user.evaluate_item!(@item,params[:score])
                present status: :success
              else
                error!("something went wrong")
              end
            end
            #}}}

          end

        end
      end
    end
  end
end
