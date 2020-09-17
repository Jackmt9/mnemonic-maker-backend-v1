require 'GeniusApiController'

class Query < ApplicationRecord
  belongs_to :user

  def self.find_lyrics_match()

  end

  def self.scrape_lyrics(song_obj)
    song_url = song_obj['response']['song']['url']
    response = HTTParty.get(song_url).body
    parsed_response = Nokogiri::HTML(response)
    lyrics = parsed_response.css('div.lyrics').text
  end


end
