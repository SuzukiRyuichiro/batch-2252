require_relative 'lion'
require_relative 'warthog'
require_relative 'meerkat'

# In another Ruby file, create an array with Simba, Nala, Timon & Pumbaa,
# iterate over it and puts the sound each animal make

# Make instances of Simba, Nala, Timon & Pumbaa,
simba = Lion.new('Simba')
nala = Lion.new('Nala')
timon = Meerkat.new('Timon')
pumbaa = Warthog.new('Pumbaa')

# put them in an array
animals = [simba, nala, timon, pumbaa]
# use #each to go over the array, and call #talk on each animal
animals.each do |animal|
  puts animal.talk
end
