class Human
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  # Class method
  def self.blood_types
    %w[A AB B O]
  end

  # Instance method
  def introduce
    puts "My name is #{name} and I'm #{age} years old"
  end
end
