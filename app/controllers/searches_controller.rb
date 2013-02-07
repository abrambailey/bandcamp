class SearchesController < ApplicationController
  def get_track
  end

  def show
    @hello = "yes"
    redirect_to root_path
  end
end
