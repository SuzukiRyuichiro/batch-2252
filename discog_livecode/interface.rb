require_relative 'scraper'
require 'json'
# TODO: scrape the discog page, generate JSON, save them into a file.

puts 'fetching top 10 URLs'
urls = fetch_master_urls

# Prepare a place to store hashes
data = []

puts 'Getting more detailed info'

urls.each do |url|
  puts "fetching #{url}"
  # psh the fetched data of an album
  data << scrape_album(url)
end

File.open('data/best_records.json', 'wb') do |file|
  file.write(JSON.pretty_generate(data))
end

puts 'Done!'
