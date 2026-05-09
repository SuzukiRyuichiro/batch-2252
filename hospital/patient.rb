class Patient
  attr_accessor :room

  # attributes = { name: 'Rie', age: 20, cured: false }
  def initialize(attributes = {}) # expect to be a hash
    @id = attributes[:id]
    @name = attributes[:name]
    @age = attributes[:age]
    @cured = attributes[:cured] || false
  end

  def cure!
    @cured = true
  end
end
