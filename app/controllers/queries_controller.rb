class QueriesController < ApplicationController
    def query_with_input
        phrase = params[:phrase]
        initials = Query.get_initials(phrase)
        matching_song_info = Query.find_song(initials)
        # pass prefered artist down to find_phrase for custom filtering
        # mnemonic = self.find_mnemonic(initials)
        # render json: mnemonic
        render json: {response: matching_song_info}
    end
end