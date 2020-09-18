Rails.application.routes.draw do
  resources :queries
  resources :users
  post '/mnemonic', to: 'queries#find_mnemonic'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
