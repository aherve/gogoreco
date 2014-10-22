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

      def check_confirmed_user!
        check_login!
        current_user.confirmed_user? || error!("please confirm account")
      end

    end
  end
end
