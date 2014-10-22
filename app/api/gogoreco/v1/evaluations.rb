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
        post :latest do

          nmax = params[:nmax] || 10

          es = Evaluation.desc(:created_at)
          if params[:school_ids]
            es = es.all_in(school_ids: school_ids)
          end

          present :evaluations, es.take(nmax), with: Gogoreco::Entities::Evaluation, entity_options: entity_options
        end

      end

    end
  end
end
