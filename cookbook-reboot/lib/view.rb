class View
  def ask_for(thing)
    puts "What is the #{thing} for the recipe?"
    gets.chomp
  end
end