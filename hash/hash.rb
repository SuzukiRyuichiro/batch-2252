tokyo = {
  "population" => 30_000_000,
  "country" => "Japan"
}

# read
puts "Tokyo is a city with #{tokyo['population']} people and in a country called #{tokyo['country']}"

# Write
tokyo['city_center'] = 'Nihonbashi'

pp tokyo

# update

# arr[1] = 'new value'
# tokyo['population'] = 31_000_000

tokyo['population'] += 1_000_000

pp tokyo

# delete

# tokyo.delete('city_center')

# pp tokyo

tokyo.each do |key, value|
  puts "Tokyo's #{key} is #{value}"
end