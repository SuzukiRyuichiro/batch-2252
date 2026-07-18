class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
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

  def new
    # prepare an empty instance of List so simple form can render the form
    @list = List.new
  end

  def create
    # Make an instance of List with the params
    @list = List.new(list_params)
    # If save was successful
    if @list.save
      # redirect to list show page
      redirect_to list_path(@list)
    else
      # If unsuccessful
      # re-render the new page with error
      render :new, status: :unprocessable_entity
    end
  end

  private

  def list_params
    # params.require(:list).permit(:name) -> pre-rails 8
    params.expect(list: [ :name ])
  end
end
