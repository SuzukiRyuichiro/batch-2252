require 'faker'
require_relative '../models/restaurant'

10.times do
  Restaurant.create!(name: Faker::Restaurant.name, address: Faker::Address.full_address)
end

puts "#{Restaurant.all.size} restaurants created!"
