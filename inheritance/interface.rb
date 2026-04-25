require_relative 'student'
require_relative 'teacher'

sammy = Teacher.new('sammy', 23, 'Language Arts')
scooter = Student.new('scooter', 20)
antonio = Student.new('Antonio', 30)

# sammy.gather_students

# Class method
# p sammy.blood_types # => weird to ask an individual
# p Human.blood_types # this feels more natural

sammy.introduce
scooter.introduce

sammy.invite_to_class(scooter)
sammy.invite_to_class(antonio)

pp sammy

