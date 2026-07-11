class ListsController < ApplicationController
  def index
    # Get all of the movie lists in the DB
    @lists = List.all
    # Render them in the view
  end
end
