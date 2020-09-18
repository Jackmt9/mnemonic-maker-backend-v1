Rails.application.routes.draw do
  resources :queries
  resources :users
  get '/search/:phrase', to: 'queries#query_with_input'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
