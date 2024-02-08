require 'pokemon_tcg_sdk'

class PokemonController < ApplicationController
  DEFAULT_PAGE_SIZE = 5

  # Método para recibir una carta de Pokémon a partir de un nombre dado...

  def get_pokemon
    pokemon_name = params[:pokemon]
    return render_error('Nombre del Pokemon no proporcionado', :unprocessable_entity) unless pokemon_name.present?

    response = Pokemon::Card.where(q: "name:#{pokemon_name}")
    return render_error('Pokemon no encontrado', :not_found) unless response.any?

    render json: response
  rescue StandardError => e
    render_error(e.message, :internal_server_error)
  end

  # Método para recibir todas las cartas disponibles, divididas por páginas

  def get_all_pokemon
    page = params[:page] || 1
    cards = Pokemon::Card.where(page: page, pageSize: DEFAULT_PAGE_SIZE)
    render json: cards
  rescue StandardError => e
    render_error(e.message, :internal_server_error)
  end

  # Método que nos devuelve la imagen de la carta
  
  def get_pokemon_img
    pokemon_name = params[:pokemon]
    return render_error('Nombre del Pokemon no proporcionado', :unprocessable_entity) unless pokemon_name.present?

    response = Pokemon::Card.where(q: "name:#{pokemon_name}")
    return render_error('Pokemon no encontrado', :not_found) unless response.any?

    first_pokemon = response.first
    img_url = first_pokemon.images.small

    return render_error('URL de imagen no encontrada', :not_found) unless img_url.present?

    img_data = Net::HTTP.get(URI.parse(img_url))
    send_data img_data, type: 'image/png', disposition: 'inline'
  rescue StandardError => e
    render_error(e.message, :internal_server_error)
  end

  private

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
