class Query < ApplicationRecord
  belongs_to :user

  # API calls
  @@base_genius_uri = 'https://api.genius.com'

  def self.get_info_by_song_id(song_id)
      response = HTTParty.get("#{@@base_genius_uri}/songs/#{song_id}?access_token=#{ENV['GENIUS_API_KEY']}")
      if response['meta']['status'] == 200
          song_url = response['response']['song']['url']
          lyrics = self.scrape_lyrics(song_url)
          response['response'][:lyrics] = lyrics
          return response
      else
          return false
      end
  end

  def self.scrape_lyrics(song_url)
      response = HTTParty.get(song_url)
      parsed_data = Nokogiri::HTML.parse(response)
      lyrics = parsed_data.css('div.lyrics').text
  end

  def self.get_artist_id_by_artist_name(artist_name)
      response = HTTParty.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
      artist_id = response["response"]["hits"][0]["result"]["primary_artist"]["id"]
  end

  def self.get_songs_by_artist_name(artist_name)
      artist_id = self.get_artist_id_by_query(artist_name)
      response = HTTParty.get("#{@@base_genius_uri}/artists/#{artist_id}/songs?access_token=#{ENV['GENIUS_API_KEY']}")
      songs = response["response"]["songs"]
  end


  # Querying Methods
  def self.get_initials(phrase)
    return phrase.split(' ').map(&:first).join.upcase
  end

  def self.find_mnemonic(initials)
    song_id = self.find_song(initials)
    # return {artist: artist, title: title, lyrics: lyrics, song_phrase: song_phrase, song_id: song_id}
  end

  def self.find_song(initials)
    song_id = rand(10000)
    song_info = self.get_info_by_song_id(song_id)
    if song_info
        song_info = song_info['response']
        matching_lyrics_index = input_is_matching(initials, song_info)

        if matching_lyrics_index
            return song_info
        else
            self.find_song(initials)
        end
    else
        self.find_song(initials)
    end
    # add error handling if runs too long
  end

  def self.add_tag_to_lyrics(song_info)
    lyrics_array = song_info[:lyrics].split(' ')

    range = song_info[:matching_range]

    lyrics_array.insert(range[1], "</span>")
    lyrics_array.insert(range[0], "<span class='matching-phrase'>")
    lyrics_array.insert(0, "<p class='full-lyrics'>")
    lyrics_array.insert(lyrics_array.length, "</p>")

    song_info[:lyrics] = lyrics_array.join(' ') 
  end

  def self.input_is_matching(initials, song_info)
    lyrics = song_info[:lyrics]
    initials_index = 0

    lyrics.split(' ').each_with_index do |lyric, index|
        if lyric[0].upcase === initials[initials_index] && initials_index != initials.length
            initials_index += 1
        elsif initials_index == initials.length
            # do we need index? maybe just matching lyrics
            # alter p tag to encorporate b tag
            song_info[:matching_range] = [index - initials.length, index]
            self.add_tag_to_lyrics(song_info)
            return true
        else
            initials_index = 0
        end
    end
    return false
  end

end
