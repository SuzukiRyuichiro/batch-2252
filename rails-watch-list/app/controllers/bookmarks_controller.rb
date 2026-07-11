class BookmarksController < ApplicationController
  def new
    # prepare an empty instance of Bookmark so simple form can render the form
    @bookmark = Bookmark.new
    # prepare the instance of List using the param in the URL
    @list = List.find(params[:list_id])
  end

  def create
    # make an instance of bookmark with the permitted params
    @bookmark = Bookmark.new(bookmark_params)
    # associate the bookmark we made to the list we found from the URL
    @list = List.find(params[:list_id])
    @bookmark.list = @list

    if @bookmark.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bookmark_params
    params.expect(bookmark: [ :comment, :movie_id ])
  end
end
