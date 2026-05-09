class Customer
  attr_accessor :id
  attr_reader :name, :address

  def initialize(attr = {})
    @id = attr[:id]
    @name = attr[:name]
    @address = attr[:address]
  end
end
