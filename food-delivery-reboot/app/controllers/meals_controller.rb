require_relative '../views/meals_view'
require_relative '../models/meal'

class MealsController
  def initialize(meal_repository)
    @meal_repository = meal_repository
    @view = MealsView.new
  end

  def add
    # ask the user for a name (view)
    name = @view.ask_for('name')
    # ask the user for a price (view)
    price = @view.ask_for('price').to_i
    # make meal instance out of those info (model)
    meal = Meal.new(name: name, price: price)
    # ask the repository to create the meal (repo)
    @meal_repository.create(meal)
  end
end
