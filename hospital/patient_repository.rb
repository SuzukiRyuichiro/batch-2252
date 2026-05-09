require_relative 'patient'
require 'csv'

class PatientRepository
  def initialize(csv_file_path, room_repository)
    @patients = []
    @csv_file_path = csv_file_path
    @room_repository = room_repository
    load_csv
  end

  private

  def load_csv
    # open the csv
    # go over row by row
    CSV.foreach(@csv_file_path, headers: true, header_converters: :symbol) do |row|
      # convert whatever non string attributes
      row[:id] = row[:id].to_i
      row[:age] = row[:age].to_i
      row[:cured] = row[:cured] == 'true'

      # Make the patient belong to a room using room_id
      #
      # 1. make the room repository available
      # 2. add ability to look for a room instance using room id
      room = @room_repository.find(row[:room_id].to_i)
      # make instance of patient using the row info
      patient = Patient.new(row)
      room.add(patient)
      # put the patient into @patients
      @patients << patient
    end
  end
end
