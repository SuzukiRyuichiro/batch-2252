class ListsController < ApplicationController
  def index
    # Get all of the movie lists in the DB
    @lists = List.all
    # Render them in the view
  end

  def show
    # Find the relevant list using ID
    @list = List.find(params[:id])
    # render the show page
  end
end
