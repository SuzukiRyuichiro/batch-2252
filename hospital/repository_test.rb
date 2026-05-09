require_relative 'room_repository'
require_relative 'patient_repository'
require_relative 'room'

# Initialize room repository
# while loading all the rows in the csv

rooms_csv_file_path = File.join(__dir__, './rooms.csv')

room_repo = RoomRepository.new(rooms_csv_file_path)

yellow_room = Room.new(name: 'yellow', capacity: 4)
room_repo.create(yellow_room)

pp room_repo

# patients_csv_file_path = File.join(__dir__, './patients.csv')

# patient_repo = PatientRepository.new(patients_csv_file_path, room_repo)

# pp patient_repo
