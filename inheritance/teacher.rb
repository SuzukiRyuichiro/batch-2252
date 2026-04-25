require_relative 'human'
class Teacher < Human
  attr_reader :expertise

  def initialize(name, age, expertise)
    super(name, age)
    @expertise = expertise
    @students = []
  end

  # Instance method
  def gather_students
    puts "Hey it's time for class!"
  end

  def invite_to_class(student) # expect Student instance as argument
    @students << student
    # update the @teacher value of the student
    student.teacher = self # refers to the instance of Teacher that called the method
  end
end
