class View
  def ask_for(thing)
    puts "What is the #{thing} for the recipe?"
    gets.chomp
  end

  def display_list(recipes) # expects an array of recipe instances
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}: #{recipe.name}: #{recipe.description}"
    end
  end
end
