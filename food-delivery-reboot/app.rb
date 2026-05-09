require_relative 'app/repositories/meal_repository'
require_relative 'app/controllers/meals_controller'
require_relative 'router'

meals_csv_file_path = File.join(__dir__, 'data/meals.csv')
meal_repository = MealRepository.new(meals_csv_file_path)
meals_controller = MealsController.new(meal_repository)

router = Router.new(meals_controller)

# Start the app
router.run
