class PagesController < ApplicationController
  def home
    @photos = Photo.where(home_page: true)
  end
end
