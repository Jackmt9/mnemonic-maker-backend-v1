class QueriesController < ApplicationController
    def find_mnemonic
        render json: {results: true}
    end
end
