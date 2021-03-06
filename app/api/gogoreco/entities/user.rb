module Gogoreco
  module Entities
    class User < Grape::Entity
      expose :pretty_id, as: :id
      expose :firstname, if: lambda {|u,o| o[:entity_options]["user"][:firstname]}
      expose :name, if: lambda {|u,o| o[:entity_options]["user"][:name]}
      expose :lastname, if: lambda {|u,o| o[:entity_options]["user"][:lastname]}
      expose :email, if: lambda {|u,o| o[:entity_options]["user"][:email]} do |u,o|
        u.public_email(o[:entity_options][:current_user])
      end

      expose :image, if: lambda {|u,o| o[:entity_options]["user"][:image]}
    end
  end
end
