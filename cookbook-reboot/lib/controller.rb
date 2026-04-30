require_relative 'view'
require_relative 'recipe'
class Controller
  def initialize(cookbook) # cookbook instance
    @cookbook = cookbook
    @view = View.new
  end

  def add
    # get the name of recipe (view)
    name = @view.ask_for('name')
    # get the description of recipe (view)
    description = @view.ask_for('description')
    # make the instance of recipe with the given info (model)
    recipe = Recipe.new(name, description)
    # put the recipe into the cookbook (cookbook aka repo)
    @cookbook.create(recipe)
  end

  def list
    display_recipe_list
  end

  def remove
    # display the recipes to the user
    display_recipe_list
    # ask the user for a number to delete
    index = @view.ask_for_index
    # ask the cookbook to destroy the said recipe
    @cookbook.destroy(index)
  end

  private

  def display_recipe_list
    # ask the cookbook to get all the recipe instances
    recipes = @cookbook.all
    # ask the view to display them nicely
    @view.display_list(recipes)
  end
end
