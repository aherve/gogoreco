module Gogoreco
  module Helpers
    module Warden

      def warden
        env['warden']
      end

      def current_user
        warden.user
      end

    end
  end
end
