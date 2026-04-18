require 'open-uri'
require 'nokogiri'

def fetch_album_urls
  # TODO: get 10 URLs of the most collected albums on discog => Array of strings
  # Define the URL we wanna scrape
  url = 'https://www.discogs.com/search?sort=have%2Cdesc&type=master'
  # Parse the URL and get the HTML of the page
  raw_html = URI.parse(url).read
  # Parse the HTML
  html_doc = Nokogiri::HTML.parse(raw_html)
  # Search for anchor tags <a> that's attached to album names
  # get the first 10 anchor tags
  first_ten_a_tags = html_doc.search('a.line-clamp-1')[0..9]

  first_ten_a_tags.map do |a_tag|
    # get href attribute of those anchor tags
    "https://www.discogs.com#{a_tag.attribute('href').value}"
  end
end

def fetch_album_details(url)
  # TODO: get details of an album of the given discog URL => Hash that have keys like 'year', 'tracks', etc

  # Parse the URL and get the HTML of the page
  raw_html = URI.parse(url).read
  # Parse the HTML
  html_doc = Nokogiri::HTML.parse(raw_html)

  title = html_doc.search('h1.title_Brnd1').text.strip.gsub(/.* – /, '')
  genres = html_doc.search('table.table_c5ftk tr:first-child a.link_wXY7O').map do |element|
    element.text.strip
  end
  tracks = html_doc.search('.trackTitleNoArtist_VUgUr span').map do |element|
    element.text.strip
  end
  artist = html_doc.search('h1 a').text.strip # sammy
  year = html_doc.search('a time').text.strip.to_i # elena

  {
    tracks: tracks,
    genres: genres,
    title: title,
    year: year,
    artist: artist
  }
end

pp fetch_album_details('https://www.discogs.com/master/24047-The-Beatles-Abbey-Road')
