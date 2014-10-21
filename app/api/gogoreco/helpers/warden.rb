module Gogoreco
  module Helpers
    module Warden

      def warden
        env['warden']
      end

      def current_user
        warden.user
      end

      def check_login!
        !!current_user || error!("please login")
      end

    end
  end
end
