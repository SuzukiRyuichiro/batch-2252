require_relative "config/application"
require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require_relative 'models/restaurant'

get "/" do
  "Hello world!"
end

get "/rie" do
  "Hello from Rie!!!"
end


# As a user I can see all the restaurants

get "/restaurants" do
  # Display all the restaurants in the db
  # "TODO: Display all restaurants"

  # Ask the DB to get me all the restaurants data. (Model / Restaurant class' job)
  @restaurants = Restaurant.all

  # Define instance variables, which would automatically passed to the view (erb)
  # @message = "Hello from app.rb"

  # Tell the view to display them nicely
  erb :index
end

# As a user, i can display a single restaurant info

get "/restaurants/:id" do
  # Find the instance of restaurant using the ID in the URL
  @restaurant = Restaurant.find(params["id"])
  # tell the view to display them nicely
  erb :show
end
