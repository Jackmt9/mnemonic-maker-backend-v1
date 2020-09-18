class QueriesController < ApplicationController
    def query_with_input
        phrase = params[:phrase]
        initials = self.get_initials(phrase)
        matching_song_info = find_song(initials)
        # pass prefered artist down to find_phrase for custom filtering
        # mnemonic = self.find_mnemonic(initials)
        # render json: mnemonic
        render json: {song: matching_song_info}
    end

    def get_initials(phrase)
        return phrase.split(' ').map(&:first).join.upcase
    end

    def find_mnemonic(initials)
        song_id = self.find_song(initials)
        # return {artist: artist, title: title, lyrics: lyrics, song_phrase: song_phrase, song_id: song_id}
    end
    
    def find_song(initials)
        song_id = rand(10000)
        song_info = self.get_info_by_song_id(song_id)
        lyrics = song_info[:lyrics]
        matching_lyrics_index = input_is_matching(initials, lyrics)

        if matching_lyrics_index
            song_info = self.add_matching_lyrics(matching_lyrics_index, song_info)
            return song_info
        else
            self.find_song(initials)
        end
        # add error handling if runs too long
    end

    def add_matching_lyrics(index, song_info)
        song_info[:matching_index] = index
    end

    def input_is_matching(initials, lyrics)
        initials_index = 0

        lyrics.split(' ').each_with_index do |lyric, index|
            if lyric[0].upcase === initials[initials_index] && initials_index != initials.length
                initials_index += 1
            elsif initials_index == initials.length
                # do we need index? maybe just matching lyrics
                # alter p tag to encorporate b tag
                return index - initials.length
            else
                initials_index = 0
            end
        end
    end

end
