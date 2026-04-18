require "json"
require "open-uri"

# TODO - Let's fetch name and bio from a given GitHub username
url = "https://api.github.com/users/ssaunier"

# Fetch the JSON
raw_data = URI.parse(url).read # String


# Parse it
parsed_data = JSON.parse(raw_data)

puts "Username is #{parsed_data["login"]} and #{parsed_data['bio']}"
