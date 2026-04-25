require_relative 'human'

class Student < Human
  attr_writer :teacher

  def initialize(name, age)
    super
    @teacher = nil
  end
end
