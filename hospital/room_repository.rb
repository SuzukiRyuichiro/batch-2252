require_relative 'room'
require 'csv'

class RoomRepository
  def initialize(csv_file_path)
    @rooms = []
    @csv_file_path = csv_file_path
    @next_id = 1
    load_csv
  end

  def find(id)
    # get a single instance with a given id out of @rooms array
    @rooms.find { |room| room.id == id }
  end

  def create(room) # receive instanc of a room w/out id
    # assign the next id to the room
    room.id = @next_id
    # put the room instance into @rooms array
    @rooms << room
    # save csv (not gonna do this now)
    # update the next id
    @next_id += 1
  end

  private

  def load_csv
    # open the csv
    # go over row by row
    CSV.foreach(@csv_file_path, headers: true, header_converters: :symbol) do |row|
      # convert whatever non string attributes
      row[:id] = row[:id].to_i
      row[:capacity] = row[:capacity].to_i
      # make instance of Room using the row info
      room = Room.new(row)
      # put the room into @rooms
      @rooms << room
    end

    # update the @next_id to be +1 of the last id
    @next_id = @rooms.empty? ? 1 : @rooms.last.id + 1
  end
end
