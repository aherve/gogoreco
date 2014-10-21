class HomeController < ApplicationController
  def index
    redirect_to "http://gogoreco.com/#/browse" if Rails.env.production?
  end
end
