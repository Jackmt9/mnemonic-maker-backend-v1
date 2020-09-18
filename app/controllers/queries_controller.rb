class QueriesController < ApplicationController
    def query_with_input
        phrase = params[:phrase]
        initials = self.get_initials(phrase)
        # pass prefered artist down to find_phrase for custom filtering
        # mnemonic = self.find_mnemonic(initials)
        # render json: mnemonic
        render json: {initials: initials}
    end

    def get_initials(phrase)
        return phrase.split(' ').map(&:first).join.upcase
    end

    def find_mnemonic(initials)
        song_id = self.find_song(initials)
        # return {artist: artist, title: title, lyrics: lyrics, song_phrase: song_phrase, song_id: song_id}
    end
    
    def find_song(initials)
        # cycle through lyrics
    end
end
