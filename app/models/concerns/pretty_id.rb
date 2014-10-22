module PrettyId
  extend ActiveSupport::Concern

  def pretty_id
    id.to_s
  end
end

