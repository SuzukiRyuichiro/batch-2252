class Room
  attr_accessor :id

  def initialize(attributes = {})
    @id = attributes[:id] || 0
    @capacity = attributes[:capacity] || 0
    @name = attributes[:name]
    @patients = attributes[:patients] || [] # an array of Patient instances
  end

  def add(patient) # an instance of Patient
    # push the patient instance into @patients array
    return if full?

    @patients << patient
    # assign room attribute to the patient
    patient.room = self
  end

  def full?
    @patients.size >= @capacity
  end
end
