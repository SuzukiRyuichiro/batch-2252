require 'json'

# TODO: - let's read/write data from beatles.json
filepath = 'data/beatles.json'

# Open the file

raw_data = File.read(filepath)

# Parse string JSON into Hash (or Array)
parsed_data = JSON.parse(raw_data)

# pp parsed_data

# puts 'John Lennon plays the Guitar'

parsed_data['beatles'].each do |member|
  puts "#{member['first_name']} #{member['last_name']} plays the #{member['instrument']}"
end


parsed_data['beatles'] << { 'first_name' => 'Ryo', 'last_name' => 'Masago', 'instrument' => 'Piano'}

generated_json = JSON.pretty_generate(parsed_data)

File.open(filepath, 'wb') do |file|
  file.write(generated_json)
end
