class HomeController < ApplicationController
  def index
    redirect_to FRONT_APP_ROOT_URL
  end
end
