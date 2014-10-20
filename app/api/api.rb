require 'grape-swagger'

class API < Grape::API
  version :v1, using: :accept_version_header, format: :json, default_format: :json do
    mount Gogoreco::V1::Ping

    add_swagger_documentation(mount_path: '/swagger_doc', markdown: true)
  end
end

