class MealsView
  def ask_for(thing)
    puts "What is the #{thing}??"
    print '> '
    gets.chomp
  end
end
