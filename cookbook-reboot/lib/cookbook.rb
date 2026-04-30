require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = [] # will store instances of Recipe
    @csv_file_path = csv_file_path
    load_csv if File.exist?(@csv_file_path)
  end

  def create(recipe) # expects Recipe instance
    @recipes << recipe
    save_to_csv
  end

  def all
    @recipes
  end

  def destroy(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  private

  def load_csv
    # Read the csv file, go over each row
    CSV.foreach(@csv_file_path) do |row|
      # create recipe instance with row
      recipe = Recipe.new(row[0], row[1])
      # put that recipe instance into @recipes array
      @recipes << recipe
    end
  end

  def save_to_csv
    # Write all the recipes into the csv
    # Open the csv file in write mode
    CSV.open(@csv_file_path, 'wb') do |csv|
      # Go over all recipes in the array
      @recipes.each do |recipe|
        # Write name, description as a row in csv
        csv << [recipe.name, recipe.description]
      end
    end
  end
end
