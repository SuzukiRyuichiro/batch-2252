require_relative 'human'

class Teacher < Human
  attr_reader :expertise

  def initialize(name, age, expertise)
    super(name, age)
    @expertise = expertise
    @students = []
  end

  def gather_students
    puts "Hey it's time for class!"
  end

  def invite_to_class(student) # Student instance as argument
    @students << student
    # update the @teacher value of the student
    student.teacher = self
  end
end
