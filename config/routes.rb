Rails.application.routes.draw do
  get '/get_pokemon', to: 'pokemon#get_pokemon'
  get 'get_all_pokemon', to: 'pokemon#get_all_pokemon'
  get 'get_pokemon_img', to: 'pokemon#get_pokemon_img'
end
