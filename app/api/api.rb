require 'grape-swagger'

class API < Grape::API
  version :v1, using: :accept_version_header, format: :json, default_format: :json do
    helpers Gogoreco::Helpers::Warden
    helpers Gogoreco::Helpers::OptionsHelper

    mount Gogoreco::V1::Entities

    mount Gogoreco::V1::Ping
    mount Gogoreco::V1::Users
    mount Gogoreco::V1::Schools
    mount Gogoreco::V1::Items
    mount Gogoreco::V1::Tags
    mount Gogoreco::V1::Evaluations
    mount Gogoreco::V1::Comments
    mount Gogoreco::V1::Profs

    add_swagger_documentation(mount_path: '/swagger_doc', markdown: true)
  end
end

