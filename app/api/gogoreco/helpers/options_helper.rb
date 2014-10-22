module Gogoreco
  module Helpers
    module OptionsHelper

      # This doesn't directly merge params[:entities], it creates a white list of acceptable attributes instead
      def entity_options
        empty_h = {
          "user" => (params[:entities]["user"] rescue nil )|| {},
          "school" => (params[:entities]["school"] rescue nil )|| {},
        }

        empty_h.merge({:current_user => current_user || User.new})
      end

      def permit_params(h,ary)
        ary.map { |attr|
          h[attr] ? {attr => h[attr]} : {}
        }.reduce({}, &:merge)
      end

    end
  end
end
