class Human
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def self.blood_types
    %w[A AB B O]
  end

  def introduce
    puts "My name is #{name} and I'm #{age} years old"
  end
end
