require 'csv'
require_relative '../models/meal'

class MealRepository
  def initialize(csv_file_path)
    @meals = []
    @next_id = 1
    @csv_file_path = csv_file_path
    load_csv if File.exist?(@csv_file_path)
  end

  def find(id)
    @meals.find { |meal| meal.id == id }
  end

  def all
    @meals
  end

  def create(meal) # expects a Meal instance
    # assign the next id to the meal
    meal.id = @next_id
    # put the meal into @meals array
    @meals << meal
    # update the next id by 1
    @next_id += 1

    # save the csv
    save_csv
  end

  private

  def load_csv
    # opne the file using CSV foreach
    CSV.foreach(@csv_file_path, headers: true, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      row[:price] = row[:price].to_i
      # go over each row to create a meal instance
      # add the meal instance into the @meals array
      @meals << Meal.new(row)
    end

    @next_id = @meals.empty? ? 1 : @meals.last.id + 1
  end

  def save_csv
    # Open the csv file in wb mode
    CSV.open(@csv_file_path, 'wb') do |csv|
      # insert the first row (header)
      csv << ['id', 'name', 'price']
      # iterate over the @meals array
      @meals.each do |meal|
        # on each meal, insert a row
        csv << [meal.id, meal.name, meal.price]
      end
    end
  end
end
