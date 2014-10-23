module Gogoreco
  module V1
    class Evaluations < Grape::API
      format :json

      namespace :evaluations do

        desc "get latest evaluations"
        params do 
          optional :nmax, type: Integer, desc:"max evals (default 10)", default: 10
          optional :school_ids, desc: "schools to filter with"
        end

        #{{{ latest
        post :latest do

          nmax = params[:nmax] || 10

          es = Evaluation.desc(:created_at)
          if params[:school_ids]
            es = es.all_in(school_ids: school_ids)
          end

          present :evaluations, es.take(nmax), with: Gogoreco::Entities::Evaluation, entity_options: entity_options
        end
        #}}}

        namespace ':evaluation_id' do 
          before do 
            params do 
              requires :evaluation_id, desc: "id of the evaluation"
            end
            @evaluation = Evaluation.find(params[:evaluation_id]) || error!("evaluation not found",404)
          end

          #{{{ update
          desc "updates evaluation score"
          params do 
            requires :score
          end
          put do 
            check_confirmed_user!
            error!("forbidden",403) unless @evaluation.author == current_user

            @evaluation.update_attribute(:score,params[:score])
            present :evaluation, @evaluation, with: Gogoreco::Entities::Evaluation, entity_options: entity_options
          end
          #}}}

          #{{{ destroy
          desc "destroy evaluation"
          delete do 
            check_confirmed_user!
            error!("forbidden",403) unless @evaluation.author == current_user

            @evaluation.destroy

            present :status, :deleted
          end
          #}}}

        end


      end

    end
  end
end
