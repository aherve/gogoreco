module Gogoreco
  module V1
    class Ping < Grape::API
      format :json

      desc "Returns pong, or passed parameter :ping if any."
      get :ping do 
        present :ping , (params[:ping] || :pong)
        present :version , 'v1'
      end

    end
  end
end
