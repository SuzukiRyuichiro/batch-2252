class Cookbook
  def initialize
    @recipes = [] # will store instances of Recipe
  end

  def create(recipe) # expects Recipe instance
    @recipes << recipe
  end

  def all
    @recipes
  end
end
