module Gogoreco
  module Entities
    class User < Grape::Entity
      expose :pretty_id, as: :id
      expose :firstname, if: lambda {|u,o| o[:entity_options]["user"][:firstname]}
      expose :lastname, if: lambda {|u,o| o[:entity_options]["user"][:lastname]}
      expose :email, if: lambda {|u,o| o[:entity_options]["user"][:email]} do |u,o|
        u.public_email(o[:entity_options][:current_user])
      end
    end
  end
end
