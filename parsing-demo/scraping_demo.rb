require 'open-uri'
require 'nokogiri'

# Let's scrape recipes from https://www.bbcgoodfood.com

puts "Type an ingredient!"
ingredient = gets.chomp

url = "https://www.bbcgoodfood.com/search?q=#{ingredient}"

raw_data = URI.parse(url).read

parsed_data = Nokogiri::HTML.parse(raw_data)

puts "Here are what I found on the web!"
parsed_data.search('a.d-block .heading-4[style*="color:inherit"]').each do |element|
  puts element.text.strip
end
