class ApplicationController < ActionController::API
    @@base_genius_uri = 'https://api.genius.com'

    def get_info_by_song_id(song_id)
        response = HTTParty.get("#{@@base_genius_uri}/songs/#{song_id}?access_token=#{ENV['GENIUS_API_KEY']}")
        song_url = response['response']['song']['url']
        lyrics = self.scrape_lyrics(song_url)
        response[:lyrics] = lyrics
        return response
    end

    def scrape_lyrics(song_url)
        response = HTTParty.get(song_url)
        parsed_data = Nokogiri::HTML.parse(response)
        lyrics = parsed_data.css('div.lyrics').text
    end

    def get_artist_id_by_artist_name(artist_name)
        response = HTTParty.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
        artist_id = response["response"]["hits"][0]["result"]["primary_artist"]["id"]
    end

    def get_songs_by_artist_name(artist_name)
        artist_id = self.get_artist_id_by_query(artist_name)
        response = HTTParty.get("#{@@base_genius_uri}/artists/#{artist_id}/songs?access_token=#{ENV['GENIUS_API_KEY']}")
        songs = response["response"]["songs"]
    end
end