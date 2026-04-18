require 'open-uri'
require 'nokogiri'

def fetch_album_details(url)
  html = URI.parse(url).read
  doc = Nokogiri::HTML.parse(html)

  # TODO: figure out the CSS selector that gets the String, Array or Integer from the page
  tracks = doc.search('.trackTitleNoArtist_VUgUr span')
  genres = doc.search('.REPLACE_THIS_WITH_YOUR_SELECTOR')
  title = doc.search('.REPLACE_THIS_WITH_YOUR_SELECTOR')
  year = doc.search('.REPLACE_THIS_WITH_YOUR_SELECTOR')
  artist = doc.search('.REPLACE_THIS_WITH_YOUR_SELECTOR')

  {
    tracks: tracks,
    genres: genres,
    title: title,
    year: year,
    artist: artist
  }
end

pp fetch_album_details('https://www.discogs.com/master/24047-The-Beatles-Abbey-Road')
