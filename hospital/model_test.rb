require_relative 'patient'
require_relative 'room'

rie = Patient.new({ name: 'Rie', age: 20 })
thomas = Patient.new({ age: 30, name: 'Thomas' })
scooter = Patient.new({ age: 30, name: 'scooter' })

red_room = Room.new(name: 'Red', capacity: 2)
blue_room = Room.new({ name: 'Blue', capacity: 2 })

red_room.add(rie)
red_room.add(thomas)
red_room.add(scooter)

pp rie.room
